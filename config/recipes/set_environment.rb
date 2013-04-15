namespace :environment_setup do
  desc "Setup environment variables for oauth"
  task :set, roles: :app do
    template 'private/environment_variables.rb.erb', "#{current_path}/config/environment_variables.rb"
  end
  after "deploy:cold", "environment_setup:set"
end
