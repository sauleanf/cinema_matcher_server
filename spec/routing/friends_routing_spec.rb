# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/friends').to route_to('friends#index')
    end
  end
end
