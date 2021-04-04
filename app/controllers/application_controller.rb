# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def encode_token(payload)
    JWT.encode(payload, secret)
  end

  def current_user
    return unless decoded_token

    user_id = decoded_token[0]['user_id']
    @current_user ||= User.find_by(id: user_id)
  end

  private

  def authenticated?
    headers = request.headers
    headers['Authorization']
  end

  def token
    request.headers['Authorization'].split(' ')[1]
  end

  def decoded_token
    return unless authenticated?

    begin
      JWT.decode(token, secret, false)
    rescue JWT::DecodeError => e
      nil
    end
  end

  def authorized?
    render json: { message: 'Authentication is required' }, status: :unauthorized unless current_user
  end

  def secret
    @secret ||= Rails.application.secrets.secret_key_base
  end
end
