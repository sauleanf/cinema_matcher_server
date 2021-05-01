# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.2'
gem 'action-cable-testing'
gem 'bcrypt', '~> 3.1.7'
gem 'draper', '~>4.0'
gem 'jbuilder', '~> 2.7'
gem 'jwt', '~>2.2'
gem 'kaminari', '~>1.2'
gem 'omniauth-google-oauth2', '~>1.0'
gem 'puma', '~> 5.0'
gem 'rack-cors', '~>1.1'
gem 'rails', '~> 6.1.3', '>= 6.1.3.1'
gem 'redis', '~> 4.0'
gem 'rubocop'
gem 'rubocop-rails'
gem 'sass-rails', '>= 6'
gem 'sqlite3', '~> 1.4'
gem 'turbolinks', '~> 5'
gem 'webpacker', '~> 5.0'
# gem 'image_processing', '~> 1.2'
gem 'bootsnap', '>= 1.4.4', require: false

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
