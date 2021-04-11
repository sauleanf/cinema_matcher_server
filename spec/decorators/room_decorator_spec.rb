# frozen_string_literal: true

require 'rails_helper'

describe RoomDecorator, type: :decorator do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:room) { Room.create(users: [user, second_user]) }
  let(:decorated_room) { room.decorate }

  it 'delegates the right fields' do
    expect(decorated_room.id).to eq(room.id)
  end

  it 'decorates the associations' do
    expect(decorated_room.users).to be_decorated
    expect(decorated_room.users).to include(user)
    expect(decorated_room.users).to include(second_user)
  end

  describe 'RoomDecorator#as_json' do
    let!(:room_json) { HashWithIndifferentAccess.new(decorated_room.as_json) }
    let!(:expected_room_hash) do
      HashWithIndifferentAccess.new(
        id: decorated_room.id,
        created_at: decorated_room.created_at.as_json,
        updated_at: decorated_room.updated_at.as_json,
        users: decorated_room.users.as_json
      )
    end

    it 'converts to json properly' do
      expect(room_json).to eq(expected_room_hash)
    end
  end
end
