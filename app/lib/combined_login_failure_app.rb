class CombinedLoginFailureApp < Devise::FailureApp
  def respond
    unless Rails.configuration.skeinlink[:use_discourse_as_sso_idp]
      super
      return
    end

    redirect
  end
end
