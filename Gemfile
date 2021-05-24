# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.7'
gem 'action-cable-testing'
gem 'aws-sdk'
gem 'aws-sdk-sqs'
gem 'bcrypt', '~> 3.1.7'
gem 'dotenv-rails', groups: %i[development test]
gem 'draper', '~>4.0'
gem 'jbuilder', '~> 2.7'
gem 'jwt', '~>2.2'
gem 'kaminari', '~>1.2'
gem 'omniauth-google-oauth2', '~>1.0'
gem 'pg'
gem 'puma', '~> 5.3', groups: %i[development test]
gem 'rack-cors', '~>1.1'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'redis', '~> 4.0'
gem 'rubocop'
gem 'rubocop-rails'
gem 'sass-rails', '>= 6'
gem 'shoryuken'
gem 'turbolinks', '~> 5'
# gem 'image_processing', '~> 1.2'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'premailer-rails'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '~> 5.0.0'

  gem 'factory_bot_rails'
end

group :development do
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'spring'
  gem 'web-console', '>= 4.1.0'
end

group :test do
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
