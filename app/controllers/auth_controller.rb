# frozen_string_literal: true

class AuthController < ApplicationController
  def login
    render json: { email: ::Messages::USER_NOT_FOUND }, status: :unauthorized and return unless user

    if user.password == login_params[:password]
      token = JsonWebToken.encode(user_id: user.id)
      render_record(user, token: token)
    else
      render json: { password: ::Messages::WRONG_CREDENTIALS }, status: :unauthorized
    end
  end

  def google_login
    @user = User.from_omniauth(google_access_token)
    token = JsonWebToken.encode(user_id: user.id)
    render json: { user: user.decorate, token: token }
  end

  private

  def google_access_token
    @google_access_token ||= request.env['omniauth.auth']
  end

  def user
    @user ||= User.find_by(email: login_params[:email])
  end

  def login_params
    params.permit(:email, :password)
  end
end
