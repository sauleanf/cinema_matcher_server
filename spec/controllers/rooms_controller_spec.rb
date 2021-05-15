# frozen_string_literal: true

require 'rails_helper'

describe RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:third_user) { create(:user) }

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
      let!(:name) { 'My New Room' }

      it 'only shows the users room' do
        get :index

        expect(response_body[:rooms]).to eq(RoomDecorator.decorate_collection(rooms).as_json)
      end

      context 'and a filter param is passed' do
        let!(:new_room) { Room.create(name: name, users: [user]) }
        it 'shows the room' do
          get :index, params: { name: name }

          expect(response_body[:rooms]).to eq([HashWithIndifferentAccess.new(new_room.decorate.as_json)])
        end
      end
    end

    describe 'GET show' do
      let(:room) { rooms.first }
      let(:other_room) { other_rooms.first }
      let(:error_res) do
        HashWithIndifferentAccess.new({ message: Messages::RECORD_NOT_FOUND })
      end

      context 'when the user is in the room' do
        it 'shows the room' do
          get :show, params: { id: room.id }

          expect(response_body[:room]).to eq(room.decorate.as_json)
        end
      end

      context 'when the user is not in the room' do
        it 'does not show the room' do
          get :show, params: { id: other_room.id }

          expect(response_body).to eq(error_res)
        end
      end
    end

    describe 'POST create' do
      let!(:create_params) do
        HashWithIndifferentAccess.new({
                                        name: 'My Room',
                                        users: [second_user.id]
                                      })
      end

      it 'creates a new room with the right data' do
        expect do
          post :create, params: create_params
        end.to change(Room, :count).by(1)

        room = Room.last

        expect(room.name).to eq(create_params[:name])
        expect(room.users).to include(user)
        expect(room.users).to include(second_user)
      end

      it 'enqueues a CreateRecommendationsJob' do
        expect(CreateRecommendationsJob).to receive(:perform_later).once

        post :create, params: create_params
      end
    end

    describe 'POST add' do
      let!(:room) { Room.create(users: [user]) }
      let!(:third_user) { create(:user) }

      it 'adds the user to the room' do
        post :add, params: { id: room.id, users: [second_user.id, third_user.id] }

        room.reload

        expect(room.users).to include(user)
        expect(room.users).to include(second_user)
        expect(room.users).to include(third_user)
      end

      it 'returns room' do
        post :add, params: { id: room.id, users: [second_user.id] }
        room.reload

        expect(response_body[:room]).to eq(room.decorate.as_json)
      end
    end
  end
end
