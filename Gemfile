source 'https://rubygems.org'

ruby '2.2.3'

# essential
gem 'sinatra', require: 'sinatra/base'
gem 'haml', '~> 5.0'
gem 'rest-client', '~> 1.8'
gem 'thin'

# debugging
gem 'awesome_print'
gem 'byebug', '~> 8.2'
gem 'pry', '~> 0.10.3'
gem 'pry-byebug', '~> 3.2'

group :production, :test do
end

group :test do
  gem 'rack-test', require: false
  gem 'rspec', '~> 3.4'
  gem 'capybara', '~> 2.5'
  gem 'webmock'
  gem 'timecop'
end
