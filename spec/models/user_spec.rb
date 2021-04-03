require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user_to_follow) { create(:user) }

  context "User#follow" do
    before do
      user.follow(user_to_follow.id)
      user.reload
      user_to_follow.reload
    end

    it "adds a new user to the user's followees" do
      expect(user.followees).to include(user_to_follow)
    end

    it "adds a new user to the other user's followers" do
      expect(user_to_follow.followers).to include(user)
    end
  end

  context "User#password" do
    let!(:new_password) { "new_password" }

    it "overrides the user password" do
      user.password = new_password
      expect(user.password).to eq(new_password)
    end
  end

  context "User#acquaintances" do
    let(:follower) { create(:user) }
    before do
      user.follow(user_to_follow.id)
      follower.follow(user.id)
      user.reload
    end

    it "displays the two users as acquaintances" do
      expect(user.acquaintances).to include(follower)
      expect(user.acquaintances).to include(user_to_follow)
    end
  end

  context "User#rooms" do
    let(:room) do
      room = Room.new
      room.users << user
      room.save!

      user.reload

      room
    end

    it "shows the users rooms" do
      expect(user.rooms).to include(room)
    end
  end
end