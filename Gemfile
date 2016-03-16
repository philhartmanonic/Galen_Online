source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use sqlite3 as the database for Active Record
# Use SCSS for stylesheets
gem 'sass', '~> 3.3'
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'foundation-rails'
gem 'paperclip'
gem 'aws-sdk', '< 2.0.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
gem 'devise'
gem 'cancancan', '~> 1.10'
gem 'redcarpet'
gem 'rouge'
gem 'pollster', '~> 0.2.3'
gem 'twitter'
gem 'omniauth-twitter'
gem 'unf_ext', '>= 0.0.7.2'
gem 'fog'
gem 'will_paginate', '~> 3.0.6'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc


# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test, :profile do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'sqlite3'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'pry-rails'
  gem 'bullet'
end

group :production do
	#use PostgreSQL as the database for Active Record
	gem 'pg', '~> 0.18.1'
end

source 'https://rails-assets.org' do
	gem 'rails-assets-angular-ui-grid'
	gem 'rails-assets-restangular'
	gem 'rails-assets-ng-rails-csrf'
	gem 'rails-assets-ngModal'
end