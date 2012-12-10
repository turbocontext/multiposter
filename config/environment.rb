# Load the rails application
require File.expand_path('../application', __FILE__)

# Load sensitive data
app_environment_variables = File.join(Rails.root, 'config', 'environment_variables.rb')
load(app_environment_variables) if File.exists?(app_environment_variables)

# Initialize the rails application
TemplateApp::Application.initialize!
