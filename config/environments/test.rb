class AdpStatPusher < Sinatra::Application

  configure do
    set :transactions_by_channel_key, 'any-old-rubbish'
    set :completion_rate_key, 'any-old-rubbish-too'
  end

end
