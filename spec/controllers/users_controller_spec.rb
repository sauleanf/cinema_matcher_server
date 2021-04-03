require "rails_helper"

describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let!(:token) do
    JsonWebToken.encode({ user_id: user.id })
  end

  def expect_auth_to_fail
    expect(response.body).to eq({ message: "Authentication is required" }.to_json)
  end

  context "when not authenticated" do
    describe "GET show" do
      it "returns an error" do
        get :show, params: { id: user.id }
        expect_auth_to_fail
      end
    end

    describe "POST create" do
      let(:user_params) do
        {
          username: "harryp",
          fullname: "harry potter",
          email: "harryp@gmail.com",
          password: "new_password"
        }
      end

      it "creates an user" do
        expect {
          post :create, params: { user: user_params }
        }.to change { User.count }.by(1)
        new_user = User.last
        expect(new_user).to have_attributes(user_params.except!(:password))
      end

      it "returns the user in the response" do
        post :create, params: { user: user_params }
        new_user = User.last
        expect(response.body).to eq(new_user.decorate.to_json)
      end
    end

    describe "PUT update" do
      it "returns the user with the right id" do
        get :show, params: { id: user.id }
        expect_auth_to_fail
      end
    end

    describe "DELETE delete" do
      it "returns the user with the right id" do
        get :show, params: { id: user.id }
        expect_auth_to_fail
      end
    end
  end

  context "when authenticated" do
    before do
      request.headers['Authorization'] = "Bearer #{token}"
    end

    describe "GET show" do
      it "returns the user with the right id" do
        get :show, params: { id: user.id }
        expect(response.body).to eq(user.decorate.to_json)
      end
    end

    describe "PUT create" do
      let(:update_user_params) do
        HashWithIndifferentAccess.new({
                                        username: "harryp",
                                        fullname: "harry potter",
                                        email: "harryp@gmail.com"
                                      })
      end

      it "updates an user" do
        put :update, params: { id: user.id, user: update_user_params }
        user.reload
        expect(user).to have_attributes(update_user_params.except!(:password))

        expect(JSON.parse(response.body)).to include(update_user_params)
      end
    end

    describe "DELETE destroy" do
      it "creates an user" do
        delete :destroy, params: { id: user.id }
        expect(User.exists?(id: user.id)).to be_falsey
      end

      it "returns the user in the response" do
        delete :destroy, params: { id: user.id }
        expect(response.body).to eq(user.decorate.to_json)
      end
    end
  end
end
