source 'https://rubygems.org'

ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# --- Gems I've added ---
# Use Mongoid for MongoDB
gem 'mongoid', '~> 4.0.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# Use figaro to protect Steam Web API Key
gem 'figaro'
# Use Bootstrap for responsive styling
gem 'bootstrap-sass', '~> 3.3.1'
# Use autoprefixer so that Bootstrapper can add vendor prefixes automatically
gem 'autoprefixer-rails'
# Use HTTParty for requests to steam web API
gem 'httparty'
# Use Hashie for easily converting parsed JSON to objects
gem 'hashie'
# Use Omniauth-steam strategy for securely logging in through steam
gem 'omniauth-steam'
# User sucker_punch for background queuing on one thread
gem 'sucker_punch', '~> 1.0'
# Require slowweb to throttle api calls to steam web api
gem 'slowweb'
# Use kaminari for pagination of results with mongoid
gem 'kaminari'


group :production do
  gem 'rails_12factor'
end

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'faker'
  gem 'pry-rails'

end

