# frozen_string_literal: true

require 'rails_helper'

describe UserDecorator, type: :decorator do
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
end
