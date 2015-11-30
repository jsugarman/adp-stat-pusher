require_relative '../app.rb'
require_relative './support/request_stubs.rb'
require 'rack/test'
require 'rspec'
require 'webmock/rspec'
require 'capybara/rspec'
require 'capybara/dsl'
require 'byebug'

set :environment, :test

WebMock.disable_net_connect!(allow_localhost: true)

module RSpecMixin
  include Rack::Test::Methods
  include Capybara::DSL
  def app
    AdpStatPusher
  end
end

RSpec.configure do |config|
  config.include RSpecMixin
  config.include RequestStubs
end

# capybara configuration
Capybara.app = AdpStatPusher

Capybara.register_driver :rack_test do |app|
  Capybara::RackTest::Driver.new(app, :headers => { 'HTTP_USER_AGENT' => 'Capybara' })
end

# helpers
def sign_in(username, password)
  authorize username, password
end
