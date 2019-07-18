#
# Cookbook:: code_generator_wrapper
# Recipe:: cookbook
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#

context = ChefDK::Generator.context
# context.enable_delivery = false

include_recipe 'code_generator::cookbook'

cookbook_dir = File.join(context.cookbook_root, context.cookbook_name)
files_dir = File.join(cookbook_dir, 'files')
directory files_dir do
  recursive true
end

# metadata.rb - customize this template
edit_resource(:template, "#{cookbook_dir}/metadata.rb") do
  cookbook 'code_generator_wrapper'
  source 'metadata.rb.erb'
end

# .foodcritic
cookbook_file "#{cookbook_dir}/.foodcritic" do
  source 'dot_foodcritic'
end

# .rubocop.yml
cookbook_file "#{cookbook_dir}/.rubocop.yml" do
  source 'dot_rubocop.yml'
end

# kitchen.yml - customize this template
edit_resource(:template, "#{cookbook_dir}/.kitchen.yml") do
  cookbook 'code_generator_wrapper'
  source 'kitchen.yml.erb'
  # no longer needs to be a hidden file, so remove the dot
  path "#{cookbook_dir}/kitchen.yml"
end
