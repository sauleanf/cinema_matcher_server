# frozen_string_literal: true

require 'rails_helper'

describe FriendRequestDecorator, type: :decorator do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:friend_request) { FriendRequest.create(user: user, other_user: second_user) }
  let(:decorated_friend_request) { friend_request.decorate }

  it 'delegates the right fields' do
    expect(decorated_friend_request.id).to eq(friend_request.id)
    expect(decorated_friend_request.status).to eq(friend_request.status)
  end

  it 'decorates the associations' do
    expect(decorated_friend_request.user).to be_decorated
    expect(decorated_friend_request.other_user).to be_decorated
  end
end
