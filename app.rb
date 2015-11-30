require 'rubygems'
require 'sinatra'
require 'haml'
require 'rest-client'
require 'json'
require "awesome_print"

require_relative './performance_dataset.rb'
require_relative './helpers.rb'

# configuration
set :root, File.dirname(__FILE__)
set :public_folder, Proc.new { File.join(root, "assets") }
set :views, Proc.new { File.join(root, "views") }
require_relative 'config/environments/production'
require_relative 'config/environments/test'

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == ENV['ADP_STAT_PUSHER_USERNAME'] and password == ENV['ADP_STAT_PUSHER_PASSWORD']
end

Tilt.register Tilt::ERBTemplate, 'html.erb'
Tilt.register Tilt::HamlTemplate, 'html.haml'

class AdpStatPusher < Sinatra::Application

  include Helpers

  get '/' do
    htaml :index, :layout => :layout
  end

  get '/about' do
    htaml :about
  end

  post '/push' do
    @responses = []


    week = params['week']
    params.delete('week')
    params.each do |dimension, count|
      next if count.empty?
      pd = build_performance_dataset(dimension,count,week)
      response = create_dataset(pd.resource, pd.payload)
    end

    htaml :push
  end

  def responses
    @responses
  end

private

  def herb(template, options={}, locals={})
    render "html.erb", template, options, locals
  end

  def htaml(template, options={}, locals={})
    render "html.haml", template, options, locals
  end

  def optional_args_for(stat_type)

    case
      when TBC_CHANNELS.include?(stat_type)
        resource = TRANSACTIONS_BY_CHANNEL
        option = 'channel'
      when CR_STAGES.include?(stat_type)
        resource = COMPLETION_RATE
        option = 'stage'
      else
        raise ArgumentError, 'Unhandled statistic type specified'
    end

    return resource, option
  end

  def build_performance_dataset(dimension, count, week)
    stat_type = dimension.to_s.split('_').first
    resource, option = optional_args_for(stat_type)
    pd = PerformanceDataset.new(resource, { option.to_sym => stat_type, :count => count.to_i, week:  week })
  end

  def api_key_for(resource)
    settings.__send__("#{resource.gsub(/[\-]+/,'_')}_api_key")
  end

  def headers_for(resource)
    headers = { :content_type => :json, :accept => :json, :Authorization => "Bearer #{api_key_for(resource)}" }
  end

  def create_dataset(resource, payload)
    url = [performance_service_url, resource].join('/')
    endpoint = RestClient::Resource.new(url, :verify_ssl => false )

    endpoint.post(payload, headers_for(resource)) do |response, request, result|
      @responses << response
    end
  rescue RestClient::ExceptionWithResponse => err
    @responses << err.response
  end

end
