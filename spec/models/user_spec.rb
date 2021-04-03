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
end