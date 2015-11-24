require 'rubygems'
require 'sinatra'
require 'haml'
require 'rest-client'
require 'json'

require_relative './helpers.rb'

require 'byebug'
require "awesome_print"


use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == 'admin' and password == 'admin'
end

Tilt.register Tilt::ERBTemplate, 'html.erb'
Tilt.register Tilt::HamlTemplate, 'html.haml'


class AdpStatPusher < Sinatra::Application

  SERVICE_NAME             = "advocate-defence-payments-agfs"
  TRANSACTIONS_BY_CHANNEL  = 'transactions-by-channel'
  COMPLETION_RATE          = 'completion-rate'

  include Helper

  get '/' do
    hhaml :index, :layout => :layout
  end

  get '/about' do
    hhaml :about
  end

  post '/push' do
    @datetime = Time.current
    # send transactions_by_channel
    # tbc_params = params
    @params = params
    # ap "params #{params}"
    # puts params.to_json
    # ap "params #{params}"

    # @params = params

     #{params[:post_paper_count]}"
    payload = build_payload_for_channel(params)
    # response = post_to_endpoint(TRANSACTION_BY_CHANNEL_ENDPOINT,)

  # send comeplete_rate


    # display success or failure
    hhaml :push
  end

private

  class PerformanceDataset

    transactions_by_channel_template = {  _id: nil ,
                                          _timestamp: nil,
                                          service: SERVICE_NAME,
                                          channel: nil,
                                          count: nil,
                                          period: 'week'
                                        }

    completion_rate_template         = {  _id: nil ,
                                          _timestamp: nil,
                                          service: SERVICE_NAME,
                                          count: nil,
                                          dataType: "journey-by-goal",
                                          stage: nil,
                                          timeSpan: "week"
                                        }

    def initialise(name, channel, count)
      @template = build_dataset_from_template(name, channel_count)
    end

  private

    def build_dataset_from_template(name, options={})
      case name
        when TRANSACTIONS_BY_CHANNEL
          t = transactions_by_channel_template
          t[:channel] = options[:channel]
          t[:count]   = options[:count]

        when COMPLETION_RATE
          t = completion_rate_template
          t[:count] = options[:count]
          t[:stage] = options[:stage]

        else
          raise ArgumentError 'Invalid dataset name specified'
      end

      t[:_id] = Secure.random
      t[:_timestamp] = Time.current
      t
    end

  end


  def parse_data(params)

  # _id: "xxxxxx",
  # _timestamp: "2015-10-16T00:00:00+00:00",
  # service: "advocate-defence-payments-agfs",
  # channel: "paper",
  # count: 123,
  # period: "week"
  # },
    datetime = Time.current

    if params[:paper_count].present?
      payload += {  _id: "xxxxxx" ,
                    _timestamp: datetime,
                    service: SERVICE_NAME,
                    channel: "paper",
                    count: params[:paper_count],
                    period: 'week'
                  }

                  PerformanceDataset.new(TRANSACTION_BY_CHANNEL, )
    end

    if params[:digital_count].present?
      payload += {  _id: "xxxxxx" ,
                    _timestamp: datetime,
                    service: SERVICE_NAME,
                    channel: "digital",
                    count: params[:digital_count],
                    period: 'week'
                  }
    end

    if params[:telephone_count].present?
        payload += {  _id: "xxxxxx" ,
                      _timestamp: datetime,
                      service: SERVICE_NAME,
                      channel: "telephone",
                      count: params[:telephone_count],
                      period: 'week'
                    }
    end

  end

  def performance_service_url
    "https://www.performance.service.gov.uk/data/#{SERVICE_NAME}/"
  end

  def herb(template, options={}, locals={})
    render "html.erb", template, options, locals
  end

  def hhaml(template, options={}, locals={})
    render "html.haml", template, options, locals
  end

  def post_to_endpoint(endpoint, payload)
    # endpoint = RestClient::Resource.new([api_root_url, prefix || ADVOCATE_PREFIX, resource].join('/'))
    endpoint = RestClient::Resource.new([performance_service_url, endpoint].join('/'))
    endpoint.post(payload, { :content_type => :json, :accept => :json } ) do |response, request, result|
      # if response.code.to_s =~ /^2/
      #   @messages << "#{endpoint} Endpoint returned success code - #{response.code}"
      # else
      #   @success = false
      #   @errors << "#{resource} Endpoint raised error - #{response.code}"
      #   @full_error_messages << "#{resource} Endpoint raised error - #{response}"
      # end
      response
    end
  end


# curl -X POST -d '<payload>' -H 'Content-type: application/json' -H 'Authorization: Bearer <bearer-token>' <url>
# You will need to change:
# <payload> for the actual json objects (conforming to the formats below)
# <bearer-token> for the tokens I'll send in a different email
# <url> for the appropriate dataset's URL shown below

# Transactions by channel
# https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/transactions-by-channel
#   {
# _id: "xxxxxx",
# _timestamp: "2015-10-16T00:00:00+00:00",
# service: "advocate-defence-payments-agfs",
# channel: "paper",
# count: 123,
# period: "week"
# },
# {
# _id: "xxxxxx",
# _timestamp: "2015-10-16T00:00:00+00:00",
# service: "advocate-defence-payments-agfs",
# channel: "paper",
# count: 456,
# period: "week"
# }
# ,
# {
# _id: "xxxxxx",
# _timestamp: "2015-10-16T00:00:00+00:00",
# service: "advocate-defence-payments-agfs",
# channel: "telephone",
# count: 789,
# period: "week"
# }

# Completion rate
# https://www.performance.service.gov.uk/data/advocate-defence-payments-agfs/completion-rate
# {
# _id: "xxxxxx",
# _timestamp: "2015-10-16T00:00:00+00:00",
# service: "advocate-defence-payments-agfs",
# count: 123,
# dataType: "journey-by-goal",
# stage: "complete",
# timeSpan: "week"
# },
# {
# _id: "xxxxxx",
# _timestamp: "2015-10-16T00:00:00+00:00",
# service: "advocate-defence-payments-agfs",
# count: 234,
# dataType: "journey-by-goal",
# stage: "start",
# timeSpan: "week"
# }

end
