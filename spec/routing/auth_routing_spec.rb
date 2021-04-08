# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthController, type: :routing do
  describe 'routing' do
    it 'routes to #login' do
      expect(post: '/api/v1/auth/login').to route_to('auth#login')
    end

    it 'routes to #google_login' do
      expect(post: '/api/v1/auth/google/login').to route_to('auth#google_login')
    end
  end
end
