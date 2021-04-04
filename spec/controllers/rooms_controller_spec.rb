# frozen_string_literal: true

require 'rails_helper'

describe RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let!(:token) do
    JsonWebToken.encode({ user_id: user.id })
  end

  def expect_auth_to_fail
    expect(response.body).to eq({ message: 'Authentication is required' }.to_json)
  end

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index
        expect_auth_to_fail
      end
    end

    describe 'GET show' do
      it 'returns an error' do
        get :show
        expect_auth_to_fail
      end
    end

    describe 'POST create' do
      it 'creates a new room' do
        get :show
        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      request.headers['Authorization'] = "Bearer #{token}"
    end

    let!(:rooms) do
      5.times.map do
        new_room = Room.create
        new_room.users = [user, second_user]
        new_room.save!

        new_room
      end
    end

    describe 'GET index' do
      it 'returns an error' do
        get :index
        expect(response.body).to eq(rooms.to_json)
      end
    end

    describe 'GET show' do
      let!(:room) do
        Room.create(users: [user])
      end

      it 'returns an error' do
        get :show, params: { id: room.id }
        expect(response.body).to eq(room.to_json)
      end
    end

    describe 'POST create' do
      it 'creates a new room with the right data' do
        expect do
          post :create, params: { room: { user_ids: [user.id, second_user.id] } }
        end.to change(Room, :count).by(1)

        room = Room.last

        expect(room.users).to include(second_user)
        expect(room.users).to include(user)
      end
    end
  end
end
