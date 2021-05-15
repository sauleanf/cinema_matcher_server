# frozen_string_literal: true

require 'rails_helper'

describe FriendsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user) }
  let!(:friendships) do
    friendship = Friendship.create(first_user: user, second_user: second_user)
    symmetric_friendship = Friendship.create(first_user: second_user, second_user: user)
    [friendship, symmetric_friendship]
  end

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET index' do
      it 'returns the user with the right id' do
        get :index

        expect(response_body[:friends]).to eq([second_user.decorate.as_json])
      end
    end
  end
end
