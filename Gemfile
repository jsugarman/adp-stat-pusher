source 'https://rubygems.org'

ruby '2.2.3'

gem 'sinatra', require: 'sinatra/base'
gem 'haml', '~> 4.0', '>= 4.0.7'
gem 'rest-client', '~> 1.8'
gem 'pry', '~> 0.10.3'
gem 'thin'

group :development, :test do
  gem 'byebug', '~> 8.2'
  gem 'pry-byebug', '~> 3.2'
  gem 'awesome_print'
end

group :development do
end

group :test do
  gem 'rack-test', require: false
  gem 'rspec', '~> 3.4'
  gem 'capybara'
  gem 'webmock'
  gem 'timecop'
end
