# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/heartcombo/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end

  def azure_activedirectory_v2
    data = request.env['omniauth.auth']['info']
    email = data['email'].downcase  # Convertir el correo electrónico a minúsculas
    @user = User.find_by(email: email)
    @user ||= User.create(
      username: data['name'],
      email: email,  # Utilizar el correo electrónico en minúsculas
      password: Devise.friendly_token[0, 20],
      #   uid: request.env['omniauth.auth']['uid'],
      #   provider: request.env['omniauth.auth']['provider']
    )
    if @user.persisted?
      flash[:notice] = "success"
      sign_in_and_redirect @user, event: :authentication
    else
      flash[:notice] = "failure"
      redirect_to new_user_registration_url
    end
  end
  
end
