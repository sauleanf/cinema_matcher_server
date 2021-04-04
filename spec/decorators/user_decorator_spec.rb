# frozen_string_literal: true

require 'rails_helper'

describe UserDecorator, type: :decorator do
  let(:num_friends) { 5 }
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:friendship) do
    friend_request = user.send_friend_request(second_user)
    data = second_user.accept_friend_request(friend_request)
    data.fetch(:friendship)
  end

  let(:decorated_user) do
    user.reload
    user.decorate
  end

  it 'delegates the right fields' do
    expect(decorated_user.id).to eq(user.id)
    expect(decorated_user.username).to eq(user.username)
    expect(decorated_user.email).to eq(user.email)
    expect(decorated_user.fullname).to eq(user.fullname)
    expect(decorated_user.profile_image).to eq(user.profile_image)
  end

  it 'conceals the password field' do
    expect(decorated_user).not_to respond_to(:password)
  end

  it 'decorates the associations' do
    expect(decorated_user.friends).to be_decorated
  end
end
