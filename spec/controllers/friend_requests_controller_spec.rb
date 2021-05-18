# frozen_string_literal: true

require 'rails_helper'

describe FriendRequestsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  let!(:friend_request) { FriendRequest.create(user: user, other_user: other_user) }

  context 'when not authenticated' do
    describe 'GET show' do
      it 'returns an error' do
        get :show, params: { id: friend_request.id }

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET show' do
      let!(:serialized_friend_request) do
        HashWithIndifferentAccess.new(friend_request.decorate.as_json)
      end

      it 'returns the friend requests belonging to the user' do
        get :show, params: { id: friend_request.id }

        expect(response_body[:item]).to eq(serialized_friend_request)
      end
    end
  end
end
