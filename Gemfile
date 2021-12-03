source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.5'

gem 'rails', '~> 6.0.4.1'
gem 'mysql2'
gem 'puma', '~> 4.3'
gem 'sass-rails', '>= 6'
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage image variants
gem 'image_processing', '~> 1.2'
gem 'active_storage_validations'

gem 'activerecord-nulldb-adapter'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'addressable'
gem 'audited'
gem 'aws-sdk-s3', require: false
gem 'bootstrap'
gem 'jquery-rails'
gem 'devise'
gem 'exception_notification'
gem 'font-awesome-sass'
gem 'kaminari'
gem 'mini_racer'
gem 'pundit'
gem 'redcarpet'
gem 'sprockets'
gem 'sprockets-rails', require: 'sprockets/railtie'

group :development, :test do
  gem 'amazing_print'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-byebug'
end

group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem 'capistrano-bundler'
  gem 'capistrano-passenger'
  gem 'ed25519'
  gem 'bcrypt_pbkdf'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'factory_bot'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
