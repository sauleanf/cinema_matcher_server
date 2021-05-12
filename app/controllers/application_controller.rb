# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  protect_from_forgery with: :null_session

  def record_not_found
    render json: { message: Messages::RECORD_NOT_FOUND }, status: :not_found
  end

  def encode_token(payload)
    JWT.encode(payload, secret)
  end

  def current_user
    return unless decoded_token

    @current_user ||= User.find_by(id: decoded_token[0]['user_id'])
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
    rescue JWT::DecodeError
      nil
    end
  end

  def authorized?
    render json: { message: Messages::AUTH_REQUIRED }, status: :unauthorized unless current_user
  end

  def secret
    @secret ||= Rails.application.secrets.secret_key_base
  end
end
