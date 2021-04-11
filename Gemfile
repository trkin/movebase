source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.x'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'capistrano', '~> 3.11'
  gem 'capistrano-rails', '~> 1.4'

  gem 'capistrano-faster-assets'
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-rbenv', '~> 2.1', '>= 2.1.4'

  gem 'capistrano-rails-console', require: false
  gem 'capistrano-rails-logs-tail'

  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'vcr'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
  gem 'webmock'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# user authentication
# https://stackoverflow.com/a/65732099
gem 'devise', github: 'heartcombo/devise', branch: 'ca-omniauth-2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
# https://stackoverflow.com/a/66155946/287166
gem 'omniauth-rails_csrf_protection'

# pick icons by: fontello open; {select icons}; fontello convert
gem 'fontello_rails_converter', '~> 0.4.6'

# bootstrap form
# use master untill new release includes https://github.com/bootstrap-ruby/bootstrap_form/pull/550
gem 'bootstrap_form', git: 'https://github.com/bootstrap-ruby/bootstrap_form.git'

# translation
gem 'mobility', '~> 0.8.6'

# money
gem 'money-rails', '~> 1.14'

# recaptcha for contact form
gem 'recaptcha'

# error notification to EXCEPTION_RECIPIENTS emails
gem 'exception_notification'

# open emails in browser
gem 'letter_opener'

# background job proccessing
gem 'sidekiq'

# geocoding
gem 'geocoder'

# enable cors for development
gem 'rack-cors'

# recurring events
gem 'montrose'
# use custom start_number
gem 'mustache'

gem 'rubyzip', '>=1.3.0'

# datatables
gem 'trk_datatables', '~>0.2.11'
# gem 'trk_datatables', path: '~/gems/trk_datatables'

# sortable
gem 'acts_as_list'
