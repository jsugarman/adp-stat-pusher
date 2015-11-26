require 'base64'
require_relative './helpers.rb'

class PerformanceDataset

  include Helper

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

    case name
      when TRANSACTIONS_BY_CHANNEL
        @resource = TRANSACTIONS_BY_CHANNEL
        t = transactions_by_channel_template
        t[:count]   = options[:count].to_i
        t[:channel] = options[:channel]
        t[:_id]     = uuid_for("#{options[:channel]}_count")

      when COMPLETION_RATE
        @resource = COMPLETION_RATE
        t = completion_rate_template
        t[:count] = options[:count].to_i
        t[:stage] = options[:stage]
        t[:_id]   = uuid_for("#{options[:stage]}_count")

      else
        raise ArgumentError 'Invalid dataset name specified'
    end

    t[:_timestamp] = Time.now.utc.strftime("%FT%T%:z")
    t.to_json
  end

  def uuid_for(stat_type)
    __send__("#{stat_type}_uuid")
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
