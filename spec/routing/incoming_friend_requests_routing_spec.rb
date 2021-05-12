# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncomingFriendRequestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/friends/incoming').to route_to('incoming_friend_requests#index')
    end

    it 'routes to #accept' do
      expect(put: '/api/v1/friends/incoming/1').to route_to('incoming_friend_requests#accept', id: '1')
    end

    it 'routes to #reject' do
      expect(delete: '/api/v1/friends/incoming/1').to route_to('incoming_friend_requests#reject', id: '1')
    end
  end
end
