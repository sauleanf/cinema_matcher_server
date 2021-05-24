# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SentFriendRequestsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/friends/sent').to route_to('sent_friend_requests#index')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/friends/sent').to route_to('sent_friend_requests#create')
    end

    it 'routes to #rescind' do
      expect(delete: '/api/v1/friends/sent/1').to route_to('sent_friend_requests#rescind', id: '1')
    end
  end
end
