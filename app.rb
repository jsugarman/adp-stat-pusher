require 'sinatra'

use Rack::Auth::Basic, 'Restricted Area' do |username, password|
  username == 'admin' and password == 'admin'
end

class AdpStatPusher < Sinatra::Application
  get '/' do
    erb :index
  end

  post '/push' do
    # send stats

  end
end
