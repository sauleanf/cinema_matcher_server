# frozen_string_literal: true

require 'rails_helper'

describe IncomingFriendRequestsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third_user) { create(:user) }

  let!(:first_incoming_friend_request) { FriendRequest.create(user: other_user, other_user: user) }
  let!(:second_incoming_friend_request) { FriendRequest.create(user: third_user, other_user: user) }
  let!(:redundant_friend_request) { FriendRequest.create(user: user, other_user: other_user) }
  let!(:unrelated_friend_request) { FriendRequest.create(user: other_user, other_user: third_user) }

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index

        expect_auth_to_fail
      end
    end

    describe 'PUT accept' do
      it 'returns an error' do
        put :accept

        expect_auth_to_fail
      end
    end

    describe 'DELETE reject' do
      it 'returns an error' do
        delete :reject

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET index' do
      it 'returns the incoming pending friend requests belonging to the user' do
        get :index

        expect(response_body).to include(first_incoming_friend_request.decorate.as_json)
        expect(response_body).to include(second_incoming_friend_request.decorate.as_json)
        expect(response_body).not_to include(redundant_friend_request.decorate.as_json)
        expect(response_body).not_to include(unrelated_friend_request.decorate.as_json)
      end
    end

    describe 'PUT accept' do
      before do
        put :accept, params: { id: first_incoming_friend_request.id }

        first_incoming_friend_request.reload
      end

      it 'creates friendships' do
        friendship = Friendship.where(first_user: user, second_user: other_user)
        symmetric_friendship = Friendship.where(first_user: other_user, second_user: user)

        expect(friendship).to be_truthy
        expect(symmetric_friendship).to be_truthy
      end

      it 'sets the friend request status' do
        expect(first_incoming_friend_request.accepted?).to be(true)
      end
    end

    describe 'DELETE reject' do
      it 'rejects the request' do
        delete :reject, params: { id: first_incoming_friend_request.id }

        first_incoming_friend_request.reload

        expect(first_incoming_friend_request.rejected?).to be(true)
      end
    end
  end
end
