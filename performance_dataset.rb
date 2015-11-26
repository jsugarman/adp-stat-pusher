require 'base64'
require_relative './helpers.rb'

class PerformanceDataset

  include Helpers

  # TODO: dry out these constants
  SERVICE_NAME             = "advocate-defence-payments-agfs"
  TRANSACTIONS_BY_CHANNEL  = 'transactions-by-channel'
  COMPLETION_RATE          = 'completion-rate'

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

  def build_payload_from_template(name, options={})

    time_now = Time.now.utc.strftime("%FT%T%:z")

    case name
      when TRANSACTIONS_BY_CHANNEL
        @resource = TRANSACTIONS_BY_CHANNEL
        t = transactions_by_channel_template
        t[:count]   = options[:count].to_i
        t[:channel] = options[:channel]
        t[:_id]     = create_id(time_now, t[:period], options[:channel])

      when COMPLETION_RATE
        @resource = COMPLETION_RATE
        t = completion_rate_template
        t[:count] = options[:count].to_i
        t[:stage] = options[:stage]
        t[:_id]   = create_id(time_now, t[:timeSpan], options[:stage])

      else
        raise ArgumentError 'Invalid dataset name specified'
    end

    t[:_timestamp] = time_now
    t.to_json
end

   # NOTE: the id must be a utf8 encoded then base64 encoded unique identifier
  #
  # The base value of the id is typically a concatenated string of
  # _timestamp, period and dimensions.
  # e.g. _timestamp value, timeSpan or period value, channel or stage
  #  => for transactions by channel this would be: _timestamp + 'week' + 'digital||paper'
  #  => for completion rate this would be: _timestamp + 'week' + 'complete||start'
  # It is used by the PP to identify the record and can
  # be used to update a record if we submit incorrent values
  # identifier.
  #
  def create_id(timestamp, period, dimension)
    value  = timestamp+period+dimension
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
      timeSpan: "week"
    }
  end

end
