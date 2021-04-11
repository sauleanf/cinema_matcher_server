# frozen_string_literal: true

require 'rails_helper'

describe RecommendationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third_user) { create(:user) }

  let!(:room) { Room.create(users: [user, other_user]) }
  let!(:pictures) do
    5.times.map { create(:picture) }
  end
  let!(:recommendations) { room.create_recommendations }

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index

        expect_auth_to_fail
      end
    end

    describe 'GET show' do
      it 'returns an error' do
        get :show, params: { id: 1 }

        expect_auth_to_fail
      end
    end

    describe 'POST create' do
      it 'returns an error' do
        post :create

        expect_auth_to_fail
      end
    end

    describe 'PUT update' do
      it 'returns an error' do
        put :update, params: { id: 1 }

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
        get :index, params: { room_id: room.id }

        expect(response_body).to include(recommendations)
      end
    end
  end
end
