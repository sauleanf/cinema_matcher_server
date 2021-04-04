# frozen_string_literal: true

require 'rails_helper'

describe SentFriendRequestsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third_user) { create(:user) }

  let!(:first_friend_request) { FriendRequest.create(user: user, other_user: other_user) }
  let!(:second_friend_request) { FriendRequest.create(user: user, other_user: third_user) }
  let!(:redundant_friend_request) { FriendRequest.create(user: other_user, other_user: user) }
  let!(:unrelated_friend_request) { FriendRequest.create(user: other_user, other_user: third_user) }

  let!(:token) { JsonWebToken.encode({ user_id: user.id }) }

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index
        expect_auth_to_fail
      end
    end

    describe 'DELETE rescind' do
      it 'returns an error' do
        delete :rescind
        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      request.headers['Authorization'] = "Bearer #{token}"
    end

    describe 'GET index' do
      it 'returns the friend requests belonging to the user' do
        get :index

        expect(response_body).to include(first_friend_request.decorate.as_json)
        expect(response_body).to include(second_friend_request.decorate.as_json)
        expect(response_body).not_to include(redundant_friend_request.decorate.as_json)
        expect(response_body).not_to include(unrelated_friend_request.decorate.as_json)
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
