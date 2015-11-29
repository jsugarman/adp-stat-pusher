class AdpStatPusher < Sinatra::Application

  configure do
    set :transactions_by_channel_api_key, ENV['TRANSACTIONS_BY_CHANNEL_KEY']
    set :completion_rate_api_key, ENV['COMPLETION_RATE_KEY']
  end

end
