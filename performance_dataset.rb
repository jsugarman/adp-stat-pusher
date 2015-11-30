require 'base64'
require_relative './helpers.rb'

class PerformanceDataset

  include Helpers

  def initialize(resource, options={} )
    @resource = resource
    @payload = build_payload_from_template(resource, options)
  end

  def resource
    @resource
  end

  def payload
    @payload
  end

private

  def timestamp_for_endpoint(weeks_ago)
    date = Date.today - weeks_ago*7
    date.monday_of_week.strftime("%FT%T%:z")
  end

  def build_payload_from_template(name, options={})
    timestamp = timestamp_for_endpoint(options[:week].to_i)

    case name
      when TRANSACTIONS_BY_CHANNEL
        @resource = TRANSACTIONS_BY_CHANNEL
        t = transactions_by_channel_template
        t[:count]   = options[:count].to_i
        t[:channel] = options[:channel]
        t[:_id]     = create_id(timestamp, t[:period], options[:channel])

      when COMPLETION_RATE
        @resource = COMPLETION_RATE
        t = completion_rate_template
        t[:count] = options[:count].to_i
        t[:stage] = options[:stage]
        t[:_id]   = create_id(timestamp, t[:period], options[:stage])

      else
        raise ArgumentError 'Invalid dataset name specified'
    end

    t[:_timestamp] = timestamp
    t.to_json
  end


   # NOTE: the id must be a utf8 encoded then base64 encoded unique identifier
  #
  # The base value of the id is typically a concatenated string of
  # _timestamp, period and dimension.
  # e.g. _timestamp value, period value, channel or stage
  #  => for transactions by channel this would be: _timestamp + 'week' + 'digital||paper'
  #  => for completion rate this would be: _timestamp + 'week' + 'complete||start'
  # It is used by the Performance platforms to identify the record and can
  # be used to update a record if we submit incorrent values
  #
  def create_id(timestamp, period, dimension)
    value = timestamp+period+dimension
    encode_id(value)
  end

  def encode_id(value)
    Base64.urlsafe_encode64(value.force_encoding(Encoding::UTF_8))
  end

  def transactions_by_channel_template
   { _id: nil ,
      _timestamp: nil,
      service: SERVICE_NAME,
      channel: nil,
      count: nil,
      period: 'week'
    }
  end

  def completion_rate_template
    { _id: nil ,
      _timestamp: nil,
      service: SERVICE_NAME,
      count: nil,
      dataType: "journey-by-goal",
      stage: nil,
      period: "week"
    }
  end

end
