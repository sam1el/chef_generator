context = ChefDK::Generator.context
repo_dir = File.join(context.repo_root, context.repo_name)
appname = (context.repo_name)

silence_chef_formatter unless context.verbose

generator_desc('Ensuring correct Effortless Chef Infra file content')

# repo root dir
directory repo_dir

# Top level files
template "#{repo_dir}/LICENSE" do
  source "LICENSE.#{context.license}.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

cookbook_file "#{repo_dir}/bootstrap.sh" do
  source 'repo/bootstrap.txt'
  action :create_if_missing
end

cookbook_file "#{repo_dir}/README.md" do
  source 'repo/EFF-README.md'
  action :create_if_missing
end

cookbook_file "#{repo_dir}/chefignore" do
  source 'chefignore'
  action :create_if_missing
end

directories_to_create = %w( cookbooks habitat )

directories_to_create += if context.use_policy
                           %w( policyfiles )
                         else
                           %w( roles environments )
                         end

directories_to_create.each do |tlo|
  remote_directory "#{repo_dir}/#{tlo}" do
    source "repo/#{tlo}"
    action :create_if_missing
  end
end

cookbook_file "#{repo_dir}/cookbooks/README.md" do
  if context.policy_only
    source 'cookbook_readmes/README-policy.md'
  else
    source 'cookbook_readmes/README.md'
  end
  action :create_if_missing
end

# git
if context.have_git
  unless context.skip_git_init
    execute('initialize-git') do
      command('git init .')
      cwd repo_dir
      not_if { File.exist?("#{repo_dir}/.gitignore") }
    end
  end
  template "#{repo_dir}/.gitignore" do
    source 'repo/gitignore.erb'
    helpers(ChefDK::Generator::TemplateHelper)
    action :create_if_missing
  end
end

# Effortless
if node['os'] == 'linux'
template "#{repo_dir}/habitat/plan.sh" do
  source "repo/plan.sh.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

template "#{repo_dir}/habitat/default.toml" do
  source "repo/lin.default.toml.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
elsif node['os'] == 'windows'
template "#{repo_dir}/habitat/plan.ps1" do
  source "repo/plan.ps1.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

template "#{repo_dir}/habitat/default.toml" do
  source "repo/win.default.toml.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
 end
end

template "#{repo_dir}/policyfiles/#{appname}.rb" do
  source "repo/effPolicyfile.rb.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

template "#{repo_dir}/habitat/README.md" do
  source "repo/eff-README.md.erb"
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end

directory "#{repo_dir}/habitat/hooks" do
  action :create
end

directory "#{repo_dir}/habitat/config" do
  action :create
end

# InSpec
directory "#{repo_dir}/test/integration/default" do
  recursive true
end

template "#{repo_dir}/test/integration/#{appname}/custom_test.rb" do
  source 'inspec_default_test.rb.erb'
  helpers(ChefDK::Generator::TemplateHelper)
  action :create_if_missing
end
