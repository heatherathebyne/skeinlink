require 'rails_helper'

# These specs could be better; if you're improving them in your own code, feel free to drop me a PR
# No need to make sure they pass in this project, just throw some code at me

# Test the SSO strategy through YarnDatabaseController,
# where it is simple to set up authed/unauthed scenarios

RSpec.describe YarnDatabaseController, type: :request do
  before do
    # assume that sso is enabled
    allow(Rails.configuration.skeinlink).to receive(:[]).and_call_original
    allow(Rails.configuration.skeinlink).to receive(:[]).with(:use_discourse_as_sso_idp).and_return(true)
    allow(Rails.configuration.skeinlink).to receive(:[]).with(:discourse_sso_url).and_return('http://discourse.local')
    allow(Rails.configuration.skeinlink).to receive(:[]).with(:discourse_sso_secret).and_return('verysecret')
    allow(Rails.configuration.skeinlink).to receive(:[]).with(:discourse_sso_return_url).and_return('http://skeinlink.local')

    # disable incompatible Devise config options
    allow(Devise).to receive(:reconfirmable).and_return(false)
    allow(Devise).to receive(:send_email_changed_notification).and_return(false)
    allow(Devise).to receive(:send_password_change_notification).and_return(false)
  end

  context 'when sso_nonce is blank' do
    # we have no SkeinLink session and have not yet started to auth with Discourse

    before { get '/yarn_database/new' }
    subject { Addressable::URI.parse(response.headers['Location']) }

    it 'sets a nonce in the session' do
      expect(request.session['sso_nonce']).to_not be_blank
    end

    it 'redirects to the configured SSO URL' do
      expect(subject.domain).to eq 'discourse.local'
    end

    # improve this spec
    it 'includes the URL encoded payload as a parameter' do
      expect(subject.query_values['sso']).to_not be_blank
    end

    # improve this spec
    it 'includes the HMAC signature as a parameter' do
      expect(subject.query_values['sig']).to_not be_blank
    end
  end

  context 'when sso_nonce is not blank' do
    # we have hit Discourse and been redirected back here

    context 'when sso response is blank' do
      # possibly the redirect to Discourse failed, or the user has managed to make a request
      # between redirect and auth -- very possible if the user is not logged in to Discourse
      before do
        set_session({ sso_nonce: '123456' })
        get '/yarn_database/new'
      end

      it 'resets the nonce and redirects to the configured SSO URL' do
        expect(session[:sso_nonce]).to_not be_nil
        expect(session[:sso_nonce]).to_not eq '123456'
        expect(Addressable::URI.parse(response.headers['Location']).domain).to eq 'discourse.local'
      end
    end

    context 'when sso response is not blank' do
      # we got a reply from Discourse, probably
      #
      # to build a response (params[:sso]):
      # your_hash = {
      #   'admin' => 'false', 'moderator' => 'false', 'avatar_url' => '', 'email' => '',
      #   'external_id' => '1234', 'groups' => '', 'name' => '', 'nonce' => '', 'return_sso_url' => 'http://test.host', 'username' => ''
      #   }
      # your_encoded_response = CGI::escape(Base64.strict_encode64(Rack::Utils.build_query(your_hash)))
      #
      # to sign a response (params[:sig]):
      # OpenSSL::HMAC.hexdigest('sha256', 'verysecret', your_encoded_response)

      let(:base_discourse_response_hash) do
        { 'admin' => 'false',
          'moderator' => 'false',
          'avatar_url' => 'http://discourse.example/avatar.png',
          'email' => 'user@mailservice.example',
          'external_id' => '1234',
          'groups' => 'trust_level_0',
          'name' => 'Test User',
          'nonce' => '123456',
          'return_sso_url' => 'http://test.host',
          'username' => 'TestUser' }
      end

      let(:encoded_sso_response) do
        CGI::escape(Base64.strict_encode64(Rack::Utils.build_query(base_discourse_response_hash)))
      end

      let(:sso_sig) do
        OpenSSL::HMAC.hexdigest('sha256',
                                Rails.configuration.skeinlink[:discourse_sso_secret],
                                encoded_sso_response)
      end

      context 'when the sso response is valid' do
        context 'when the local user exists' do
          let!(:user) { create(:user, idp_uid: 1234) }

          before do
            set_session({ sso_nonce: '123456' })
            get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
            user.reload
          end

          it 'updates the local user name and email' do
            expect(user.name).to eq 'TestUser' # params[:username]
            expect(user.email).to eq 'user@mailservice.example'
          end

          context 'but does not have an idp_uid' do
            it 'updates the local user name and idp_uid' do
              expect(user.name).to eq 'TestUser'
              expect(user.idp_uid).to eq 1234
            end
          end

          it 'renders the requested page' do
            expect(response).to render_template('yarn_database/new')
          end
        end

        context 'when the local user does not exist' do
          it 'creates the local user' do
            set_session({ sso_nonce: '123456' })
            get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
            new_user = User.find_by(idp_uid: 1234)
            expect(new_user.name).to eq 'TestUser'
            expect(new_user.email).to eq 'user@mailservice.example'
          end
        end
      end

      context 'when the sso response is not valid' do
        context 'when the external_id is invalid' do
          context 'when the external_id is blank' do
            let(:base_discourse_response_hash) do
              { 'admin' => 'false',
                'moderator' => 'false',
                'avatar_url' => 'http://discourse.example/avatar.png',
                'email' => 'user@mailservice.example',
                'external_id' => '',
                'groups' => 'trust_level_0',
                'name' => 'Test User',
                'nonce' => '123456',
                'return_sso_url' => 'http://test.host',
                'username' => 'TestUser' }
            end

            it 'raises an exception' do
              set_session({ sso_nonce: '123456' })
              expect {
                get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
              }.to raise_error(ArgumentError)
            end
          end

          context 'when the external_id is not an integer' do
            let(:base_discourse_response_hash) do
              { 'admin' => 'false',
                'moderator' => 'false',
                'avatar_url' => 'http://discourse.example/avatar.png',
                'email' => 'user@mailservice.example',
                'external_id' => 'POTATO',
                'groups' => 'trust_level_0',
                'name' => 'Test User',
                'nonce' => '123456',
                'return_sso_url' => 'http://test.host',
                'username' => 'TestUser' }
            end

            it 'raises an exception' do
              set_session({ sso_nonce: '123456' })
              expect {
                get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
              }.to raise_error(ArgumentError)
            end
          end
        end

        context 'when the HMAC signature is incorrect' do
          let(:sso_sig) { 'bogus_signature' }

          it 'raises a HMAC validation exception' do
            set_session({ sso_nonce: '123456' })
            expect {
              get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
            }.to raise_error('SSO response failed HMAC validation. This could indicate tampering.')
          end
        end

        context 'when the response is invalid base64' do
          let(:encoded_sso_response) { 'invalid base64' }

          it 'raises a base64 exception' do
            set_session({ sso_nonce: '123456' })
            expect {
              get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
            }.to raise_error('SSO response was not base64 encoded.')
          end
        end

        context 'when the nonce does not match' do
          it 'raises a nonce mismatch exception' do
            set_session({ sso_nonce: '314159' })
            get '/yarn_database/new', params: { sso: encoded_sso_response, sig: sso_sig }
            follow_redirect!
            expect(response.body).to match('We were unable to log you in')
          end
        end
      end
    end
  end
end
