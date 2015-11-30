require_relative './spec_helper.rb'

describe 'AdpStatPusher' do

  before(:each) { sign_in ENV['ADP_STAT_PUSHER_USERNAME'], ENV['ADP_STAT_PUSHER_PASSWORD'] }

  context 'authentication' do
    context 'should require valid authentication' do

      it 'should prevent access for invalid credentials' do
        sign_in 'bad' , 'boy'
        get '/'
        expect(last_response).to_not be_ok
      end

      it 'should grant access for valid credentials' do
        get '/'
        expect(last_response).to be_ok
      end

    end
  end


  describe 'pushing', :type => :feature do


    before do
      stub_all_posts_with_success
    end

    context 'with no params' do
      it 'should return success regardless' do
        post '/push'
        expect(last_response).to be_ok
        expect(last_response.body).to have_content('No responses')
      end
    end

    context 'with valid params' do
      %w( paper digital complete start ).each do |dimension|
        it "should successfully post data to #{dimension} endpoint" do
          post '/push', { "#{dimension}_count".to_sym => '102', week: '1' }
          expect(last_response).to be_ok
          expect(last_response.body).to have_content(dimension)
          expect(last_response.body).to have_content('ok')
          expect(last_response.body).to have_content('view results')
        end
      end
    end

    context 'with invalid params' do
      it 'should raise error before pushing' do
        expect{ post '/push', { 'unknown_count' => '102', 'week' => '1' } }.to raise_error(ArgumentError, 'Unhandled statistic type specified')
      end
    end

  end

end