# frozen_string_literal: true

module ControllerHelpers
  def expect_auth_to_fail
    expect(response.body).to eq({ message: 'Authentication is required' }.to_json)
  end

  def response_body
    body = JSON.parse(response.body)
    if body.is_a? Array
      body.map { |obj| HashWithIndifferentAccess.new(obj) }
    else
      HashWithIndifferentAccess.new(body)
    end
  end

  def login_user(user)
    token = JsonWebToken.encode({ user_id: user.id })
    request.headers['Authorization'] = "Bearer #{token}"
  end
end

RSpec.configure do |c|
  c.include ControllerHelpers
end
