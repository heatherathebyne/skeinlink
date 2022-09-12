# This is a Devise-compatible Warden strategy for authenticating with Discourse as SSO IdP.
# Based on https://github.com/AstonJ/sso_with_discourse ,
# which is based on https://meta.discourse.org/t/using-discourse-as-a-sso-provider/32974 .
#
# If you are reusing this strategy in another application, you will need:
# - This file
#
# - An initializer containing the following:
#     Warden::Strategies.add(:sso_with_discourse, SsoWithDiscourseStrategy)
#
# - Devise configuration to add this as the first default strategy:
#     Devise.setup do |config|
#       config.warden do |manager|
#         manager.default_strategies(scope: :user).unshift :sso_with_discourse
#       end
#     end
#
# - Your own config source for :discourse_sso_secret, :discourse_sso_url,
#                              :discourse_sso_return_url, and :use_discourse_as_sso_idp
#
# - A column in your users table for the upstream unique id
#
# - Specs from spec/requests/sso_with_discourse_strategy_spec.rb

class SsoWithDiscourseStrategy < Devise::Strategies::Base
  def valid?
    # should we try to run this strategy in the first place?
    return false unless Rails.configuration.skeinlink[:use_discourse_as_sso_idp]

    # Check for incompatible Devise settings
    if Devise.reconfirmable || Devise.send_email_changed_notification || Devise.send_password_change_notification
      raise 'Please disable Devise options reconfirmable, send_email_changed_notification, '\
            'and send_password_change_notification. These options are incompatible with the '\
            'Discourse SSO authentication strategy.'
    end

    true
  end

  def authenticate!
    # an unauthenticated user has hit an auth-only page, so now we are here

    # if there is no session nonce, or we don't have a Discourse response, we are starting fresh
    # redirect_to SsoWithDiscourse.new.request_url with the params which discourse wants,
    # and hang on to the nonce for later validation
    # discourse will auth the user and redirect back to us
    unless session[:sso_nonce] && parsed_params
      session[:sso_nonce] = SecureRandom.hex(16)

      raw_payload = "nonce=#{ session[:sso_nonce] }&return_sso_url=#{ Rails.configuration.skeinlink[:discourse_sso_return_url] }"

      base64_encoded_payload = Base64.encode64(raw_payload)

      url_encoded_payload = URI::Parser.new.escape(base64_encoded_payload)

      hex_signature = hmac_hex_string(base64_encoded_payload)

      redirect! "#{ Rails.configuration.skeinlink[:discourse_sso_url] }?sso=#{ url_encoded_payload }&sig=#{ hex_signature }"

      return
    end

    # if discourse says they're cool, we want to let them in,
    # even if we have to make a local account
    # one hopes that one gets a unique uid in the response params,
    # which we should use to look up a local user
    # and if no user matches, we create an account for them
    user = User.find_or_initialize_by(idp_uid: Integer(parsed_params[:external_id]))

    # let's hang on to their email -- update it if it changed in discourse
    # I suspect we will want it later
    user.email = parsed_params[:email]
    user.name = parsed_params[:username]

    # make devise happy
    user.confirmed_at = Time.current
    user.password = SecureRandom.hex(8) # bogus password

    unless user.save
      # if email is already taken, use that User instead
      if user.errors.of_kind?(:email, :taken)
        user = User.find_by(email: parsed_params[:email])
        fail! unless user

        user.idp_uid = parsed_params[:external_id]
        user.name = parsed_params[:username]
        fail!(user) unless user.save
      else
        fail!(user)
      end
    end

    # anyhow, if we're here with a happy little sso response,
    # we probably don't have any further reasons to reject the user
    # so this method should always end with a happily authed user,
    # redirected to the original page they hit.
    success!(user)

    # Devise will now reset the session, so sso_nonce will be cleared
  end

  private

  def parsed_params
    begin
      @parsed_params ||= parse_discourse_sso_response
    rescue StandardError => e
      # little bit lazy, but I do want to be notified if Discourse is sending back bad responses
      raise e if e.class == RuntimeError
      nil
    end
  end

  def parse_discourse_sso_response
    if hmac_hex_string(params[:sso]) == params[:sig]
      if base64?(CGI::unescape(params[:sso]))
        decoded_hash = Rack::Utils.parse_query(CGI::unescape(Base64.decode64(params[:sso])))
        decoded_hash.symbolize_keys!

        if decoded_hash[:nonce] == session[:sso_nonce]
          decoded_hash
        else
          # most likely, if we are here, the unauthenticated user:
          # was not logged in to Discourse;
          # has been redirected to Discourse in two different browser tabs;
          # and has logged in on the earlier browser tab, with the old nonce which has since been cleared
          reset_session!
          fail!('We were unable to log you in. Please close all other SkeinLink browser tabs and try again.')
          throw(:warden)
        end
      else
        raise 'SSO response was not base64 encoded.'
      end
    else
      raise 'SSO response failed HMAC validation. This could indicate tampering.'
    end
  end

  def hmac_hex_string(payload)
    OpenSSL::HMAC.hexdigest("sha256", Rails.configuration.skeinlink[:discourse_sso_secret], payload)
  end

  def base64? data
    !(data =~ /[^a-zA-Z0-9=\r\n\/+]/m)
  end
end
