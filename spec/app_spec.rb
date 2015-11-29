require_relative './spec_helper.rb'

describe 'AdpStatPusher' do

  context 'authentication' do
    context 'should require valid authentication' do

      it 'should prevent access for invalid credentials' do
        sign_in 'bad' , 'boy'
        get '/'
        expect(last_response).to_not be_ok
      end

      it 'should grant access for valid credentials' do
        sign_in ENV['ADP_STAT_PUSHER_USERNAME'], ENV['ADP_STAT_PUSHER_PASSWORD']
        get '/'
        expect(last_response).to be_ok
      end

    end
  end

end