# spec/spec_helper.rb
require 'rack/test'
require 'sinatra'
require 'webmock/rspec'
require 'capybara/rspec'
require 'pry'
require 'awesome_print'
require 'byebug'
require 'timecop'

ENV['RACK_ENV'] = 'test'

require_relative '../app.rb'

Capybara.app = AdpStatPusher

module RSpecMixin
  include Rack::Test::Methods
  def app() AdpStatPusher end
end

# For RSpec 2.x
RSpec.configure do |config|
  config.include RSpecMixin
  config.include Helpers
end

def sign_in(username, password)
  # request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("#{username}:#{password}")
   # byebug
  basic_authorize username, password
end

def basic_auth
  page.driver.header('Authorization', 'Basic '+ Base64.encode64('test pass:X'))
end