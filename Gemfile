source "https://rubygems.org"
ruby "2.2.4"

gem "paperclip"
# Amazon web services
gem 'aws-sdk', '~> 2'

gem 'rails-erd'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'materialize-sass'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'hirb'
gem 'jquery-ui-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 2.2.2'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'activerecord-reset-pk-sequence'

gem 'acts-as-taggable-on'

gem 'simple_form'

gem 'rails_autolink'

gem 'perfect-scrollbar-rails'

gem 'rails_12factor'

# Use ActiveModel has_secure_password

# Use Unicorn as the app server
# gem 'unicorn'

group :production do
  gem 'pg'
  gem 'pundit'
  gem 'bcrypt'
  gem 'figaro'
  gem 'whenever', require: false

end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  #testing
  gem 'capybara'
  gem 'rspec-rails'
  gem 'pundit'
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  gem 'figaro'
  gem "nifty-generators"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

gem 'mocha', group: :test
