# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:room) { Room.create(users: [user, second_user]) }

  before do
    user.reload
    second_user.reload
  end

  context 'Room#users' do
    it 'shows the users in the room' do
      expect(room.users).to include(user)
      expect(room.users).to include(second_user)
    end
  end
end
