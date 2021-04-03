require "rails_helper"

describe UserDecorator, type: :decorator do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:decorated_user) { user.decorate }

  it "delegates the right fields" do
    expect(decorated_user.id).to eq(user.id)
    expect(decorated_user.username).to eq(user.username)
    expect(decorated_user.email).to eq(user.email)
    expect(decorated_user.fullname).to eq(user.fullname)
    expect(decorated_user.profile_image).to eq(user.profile_image)
  end

  it "conceals the password field" do
    expect(decorated_user).not_to respond_to(:password)
  end
end