# frozen_string_literal: true

require 'rails_helper'

describe RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:third_user) { create(:user) }

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
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    let(:num_rooms) { 5 }
    let!(:rooms) do
      num_rooms.times.map do
        Room.create(users: [user, second_user])
      end
    end
    let!(:other_rooms) do
      num_rooms.times.map do
        Room.create(users: [second_user, third_user])
      end
    end

    describe 'GET index' do
      it 'only shows the users room' do
        get :index

        expect(response_body).to eq(rooms.as_json)
      end
    end

    describe 'GET show' do
      let(:room) { rooms.first }
      let(:other_room) { other_rooms.first }

      context 'when the user is in the room' do
        it 'shows the room' do
          get :show, params: { id: room.id }

          expect(response_body).to eq(room.decorate.as_json)
        end
      end

      context 'when the user is not in the room' do
        it 'does not show the room' do
          get :show, params: { id: other_room.id }

          expect_message(Messages::RECORD_NOT_FOUND)
        end
      end
    end

    describe 'POST create' do
      it 'creates a new room with the right data' do
        expect do
          post :create
        end.to change(Room, :count).by(1)

        room = Room.last

        expect(room.users).to include(user)
      end

      it 'enqueues a CreateRecommendationsJob' do
        expect(CreateRecommendationsJob).to receive(:perform_later).once

        post :create
      end
    end

    describe 'POST add' do
      let!(:room) { Room.create(users: [user]) }
      let!(:third_user) { create(:user) }

      it 'adds the user to the room' do
        post :add, params: { id: room.id, room: { user_ids: [second_user.id, third_user.id] } }

        room.reload

        expect(room.users).to include(user)
        expect(room.users).to include(second_user)
        expect(room.users).to include(third_user)
      end

      it 'returns room' do
        post :add, params: { id: room.id, room: { user_ids: [second_user.id] } }
        room.reload

        expect(response_body).to eq(room.decorate.as_json)
      end
    end
  end
end
