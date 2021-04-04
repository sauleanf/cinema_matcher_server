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
end
