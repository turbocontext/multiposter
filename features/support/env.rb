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
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  require 'cucumber/rails'

  Capybara.default_selector = :css

  Capybara.javascript_driver = :webkit

  ActionController::Base.allow_rescue = false

  # Remove/comment out the lines below if your app doesn't have a database.
  # For some databases (like MongoDB and CouchDB) you may need to use :truncation instead.
  begin
    DatabaseCleaner.strategy = :transaction
  rescue NameError
    raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
  end

  Cucumber::Rails::Database.javascript_strategy = :truncation

end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
    SimpleCov.start 'rails'
  end
  # This code will be run each time you run your specs.

end


