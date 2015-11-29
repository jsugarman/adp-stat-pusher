require_relative '../app.rb'
require 'rack/test'
require 'rspec'
# require 'webmock/rspec'
# require 'capybara/rspec'

require 'byebug'

set :environment, :test

module RSpecMixin
  include Rack::Test::Methods
  def app
    AdpStatPusher
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  # config.include Helpers
end

def sign_in(username, password)
  authorize username, password
end
