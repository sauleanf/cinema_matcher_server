# frozen_string_literal: true

require 'rails_helper'

describe FriendRequestDecorator, type: :decorator do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:friend_request) { FriendRequest.create(user: user, other_user: other_user) }
  let(:decorated_friend_request) { friend_request.decorate }

  it 'delegates the right fields' do
    expect(decorated_friend_request.id).to eq(friend_request.id)
    expect(decorated_friend_request.status).to eq(friend_request.status)
  end

  it 'decorates the associations' do
    expect(decorated_friend_request.user).to be_decorated
    expect(decorated_friend_request.other_user).to be_decorated
  end

  describe 'FriendRequestDecorator#as_json' do
    let!(:friend_request_json) { HashWithIndifferentAccess.new(decorated_friend_request.as_json) }
    let!(:expected_friend_request_hash) do
      HashWithIndifferentAccess.new(
        id: friend_request.id,
        user: user.decorate.as_json,
        other_user: other_user.decorate.as_json,
        status: decorated_friend_request.status,
        created_at: decorated_friend_request.created_at.as_json,
        updated_at: decorated_friend_request.updated_at.as_json
      )
    end

    it 'converts to json properly' do
      expect(friend_request_json).to eq(expected_friend_request_hash)
    end
  end
end
