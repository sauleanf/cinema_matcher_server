require "rails_helper"

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:room) do
    room = Room.new
    room.users = [user, second_user]
    room.save!

    user.reload

    room
  end

  context "Room#users" do
    it "shows the users in the room" do
      expect(room.users).to include(user)
      expect(room.users).to include(second_user)
    end
  end
end