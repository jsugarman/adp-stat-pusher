require 'rubygems'
require 'sinatra'
require 'haml'
require 'rest-client'
require 'json'

require_relative './performance_dataset.rb'
require_relative './helpers.rb'

require "awesome_print"

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == ENV['ADP_STAT_PUSHER_USERNAME'] and password == ENV['ADP_STAT_PUSHER_PASSWORD']
end

Tilt.register Tilt::ERBTemplate, 'html.erb'
Tilt.register Tilt::HamlTemplate, 'html.haml'

class AdpStatPusher < Sinatra::Application

  include Helpers

  TBC_CHANNELS = %w( paper digital )
  CR_STAGES    = %w( complete start )

  get '/' do
    htaml :index, :layout => :layout
  end

  get '/about' do
    htaml :about
  end

  post '/push' do
    @responses = []

    params.each do |k,v|
      next if v.empty?
      pd = build_performance_dataset(k,v)
      response = create_dataset(pd.resource, pd.payload)
    end

    htaml :push
  end

  def responses
    @responses
  end
  
  def performance_service_url
    "https://www.performance.service.gov.uk/data/#{SERVICE_NAME}"
  end

private

  def herb(template, options={}, locals={})
    render "html.erb", template, options, locals
  end

  def htaml(template, options={}, locals={})
    render "html.haml", template, options, locals
  end

  def optional_args(stat_type)

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

  def build_performance_dataset(key, value)
    stat_type = key.to_s.split('_').first
    count = value.to_i
    resource, option = optional_args(stat_type)
    pd = PerformanceDataset.new(resource, { option.to_sym => stat_type, :count => count })
  end

  def api_key_for(resource)
    __send__("#{resource.gsub(/[\-]+/,'_')}_key")
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
