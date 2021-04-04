# frozen_string_literal: true

class AuthController < ApplicationController
  def login
    if user.password == login_params[:password]
      token = JsonWebToken.encode(user_id: user.id)
      render json: { user: user.decorate, token: token }
    else
      render json: { msg: 'Credential are wrong' }, status: :unauthorized
    end
  end

  private

  def user
    @user ||= User.find_by(email: login_params[:email])
  end

  def login_params
    params.require(:credentials).permit(:email, :password)
  end
end
