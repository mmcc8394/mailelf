source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails'
gem 'pg'
gem 'sass-rails'
gem 'webpacker'
gem 'turbolinks'
gem 'bootstrap'
gem 'jquery-rails'
gem 'octicons'
gem 'octicons_helper'
gem 'delayed_job_active_record'
gem 'daemons'

gem 'bcrypt'
gem 'pundit'
gem 'enumerize'

gem 'bootsnap', require: false

gem 'passenger', require: 'phusion_passenger/rack_handler'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'letter_opener'
  gem 'capistrano', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano3-delayed-job', require: false

  gem 'ed25519'
  gem 'bcrypt_pbkdf'
end

group :test do
  gem 'capybara'
end
