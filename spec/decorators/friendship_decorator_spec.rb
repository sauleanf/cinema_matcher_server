# frozen_string_literal: true

require 'rails_helper'

describe FriendshipDecorator, type: :decorator do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:friendship) { Friendship.create(first_user: user, second_user: second_user) }
  let(:decorated_friendship) { friendship.decorate }

  it 'delegates the right fields' do
    expect(decorated_friendship.id).to eq(friendship.id)
  end

  it 'decorates the associations' do
    expect(decorated_friendship.first_user).to be_decorated
    expect(decorated_friendship.second_user).to be_decorated
  end

  describe 'FriendshipDecorator#as_json' do
    let!(:friendship_json) { HashWithIndifferentAccess.new(decorated_friendship.as_json) }
    let!(:expected_friendship_hash) do
      HashWithIndifferentAccess.new(
        id: friendship.id,
        first_user: user.decorate.as_json,
        second_user: second_user.decorate.as_json,
        created_at: friendship.created_at.as_json,
        updated_at: friendship.updated_at.as_json
      )
    end

    it 'converts to json properly' do
      expect(friendship_json).to eq(expected_friendship_hash)
    end
  end
end
