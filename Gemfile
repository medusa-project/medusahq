source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.2'
gem 'bootstrap', '~> 4.1'
gem 'httpclient'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'pg'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'activerecord-session_store'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# write views in Haml
gem 'haml-rails'

# simplify form creation
gem 'simple_form'

#pagination
gem 'will_paginate-bootstrap4'

#configuration
gem 'config'

#authentication
gem 'omniauth-shibboleth'

#progress meter
gem 'progress_bar'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'simplecov'
  gem 'minitest-matchers_vaccine'
  gem 'shoulda', '~> 3.5'
  gem 'shoulda-matchers', '~> 2.0'
  gem 'rspec-expectations'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
