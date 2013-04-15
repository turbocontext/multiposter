set :rvm_ruby_string, '1.9.3-p327'

set :rvm_type, :user
set :rvm_install_ruby_params, ' --verify-downloads 1' # no checksum comparsion
before 'deploy:setup', 'rvm:install_rvm'   # install RVM
before 'deploy:setup', 'rvm:install_ruby'  # install Ruby and create gemset, or:

require "rvm/capistrano"
require "bundler/capistrano"

