# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FriendRequest, type: :model do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:friend_request) { FriendRequest.create(user: user, other_user: other_user) }

  describe 'validate' do
    it 'ensures that there are no duplicates' do
      duplicate_friend_requests = FriendRequest.new(user: user, other_user: user)

      expect(duplicate_friend_requests.valid?).to be(false)
    end
  end
end
