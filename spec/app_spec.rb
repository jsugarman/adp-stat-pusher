require_relative './spec_helper.rb'


describe 'AdpStatPusher' do
  include Rack::Test::Methods

  def app
    AdpStatPusher
  end

  #
  # TODO spec app
  #
  # before (:each) { sign_in 'admin','admin' }

  xit 'should allow access to the home page' do
    authorize 'admin' , 'admin'
    get '/'
    expect(last_response).to be_ok
  end

end