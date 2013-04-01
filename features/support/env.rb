require 'rubygems'
require 'spork'
require "database_cleaner"
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  require 'cucumber/rails'

  Capybara.default_selector = :css
  # Capybara.server_port = 57124
  Capybara.javascript_driver = :webkit
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end

  ActionController::Base.allow_rescue = false
  begin
    DatabaseCleaner.strategy = :transaction
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end

  # Cucumber::Rails::Database.javascript_strategy = :truncation

end

