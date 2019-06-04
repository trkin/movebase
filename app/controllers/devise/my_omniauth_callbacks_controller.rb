module Devise
  class MyOmniauthCallbacksController < OmniauthCallbacksController
    # https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
    # data is in request.env["omniauth.auth"]
    [:facebook, :google_oauth2, :twitter].each do |provider| # yaho_oauth2
      define_method provider do
        # use request.env["omniauth.params"]["my_param"]
        user = User.from_omniauth(request.env['omniauth.auth'], request.env['omniauth.params'])
        sign_in_and_redirect user, event: :authentication
        set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
      end

      def failure
        # this could be: no_authorization_code # when we did not whitelisted domain
        # on facebook app settings
        alert = t('can_not_sign_in')
        alert += " #{request.env['omniauth.error'].try(:message)} #{request.env['omniauth.error.type']}"
        redirect_to root_path, alert: alert
      end
    end
  end
end
