# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequestsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/friends/requests/1').to route_to('friend_requests#show', id: '1')
    end
  end
end
