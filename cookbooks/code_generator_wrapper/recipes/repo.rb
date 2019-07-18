context = ChefDK::Generator.context
repo_dir = File.join(context.repo_root, context.repo_name)

# context.enable_delivery = false

include_recipe 'code_generator::effortless'

# kitchen.yml - customize this template
edit_resource(:template, "#{repo_dir}/effkitchen.yml") do
  cookbook 'code_generator_wrapper'
  source 'effkitchen.yml.erb'
  # needs to be renamed
  path "#{repo_dir}/kitchen.yml"
end
