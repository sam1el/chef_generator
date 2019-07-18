context = ChefDK::Generator.context
# context.enable_delivery = false

include_recipe 'code_generator::effortless'

# kitchen.yml - customize this template
edit_resource(:template, "#{effortless_dir}/effkitchen.yml") do
  cookbook 'code_generator_wrapper'
  source 'effkitchen.yml.erb'
  # needs to be renamed
  path "#{effortless_dir}/kitchen.yml"
end
