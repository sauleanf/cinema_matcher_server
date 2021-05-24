# frozen_string_literal: true

require 'rails_helper'

describe SentFriendRequestsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third_user) { create(:user) }
  let!(:fourth_user) { create(:user) }

  let!(:first_friend_request) { FriendRequest.create(user: user, other_user: other_user) }
  let!(:second_friend_request) { FriendRequest.create(user: user, other_user: third_user) }
  let!(:redundant_friend_request) { FriendRequest.create(user: other_user, other_user: user) }
  let!(:unrelated_friend_request) { FriendRequest.create(user: other_user, other_user: third_user) }

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index

        expect_auth_to_fail
      end
    end

    describe 'POST create' do
      it 'returns an error' do
        post :create, params: { other_user_id: fourth_user.id }

        expect_auth_to_fail
      end
    end

    describe 'DELETE rescind' do
      it 'returns an error' do
        delete :rescind, params: { id: first_friend_request.id }

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET index' do
      let!(:serialized_friend_requests) do
        [
          HashWithIndifferentAccess.new(first_friend_request.decorate.as_json),
          HashWithIndifferentAccess.new(second_friend_request.decorate.as_json)
        ]
      end

      it 'returns the friend requests belonging to the user' do
        get :index

        expect(response_body[:items]).to eq(serialized_friend_requests)
      end
    end

    describe 'POST create' do
      it 'creates a friend request' do
        post :create, params: { other_user: fourth_user.id }

        friend_request = FriendRequest.find_by(user: user, other_user: fourth_user)

        expect(friend_request.pending?).to be(true)
      end
    end

    describe 'DELETE reject' do
      it 'rescinds the request' do
        delete :rescind, params: { id: first_friend_request.id }

        first_friend_request.reload

        expect(first_friend_request.rescinded?).to be(true)
      end
    end
  end
end
