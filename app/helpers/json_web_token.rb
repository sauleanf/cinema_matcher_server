# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload)
    JWT.encode(payload, secret)
  end

  def self.decode(token)
    HashWithIndifferentAccess.new(JWT.decode(token, secret).first)
  end

  def self.secret
    Rails.application.credentials.secret_key_base
  end
end
