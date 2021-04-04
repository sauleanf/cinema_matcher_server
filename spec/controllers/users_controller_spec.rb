# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let!(:token) { JsonWebToken.encode({ user_id: user.id }) }

  context 'when not authenticated' do
    describe 'GET show' do
      it 'returns an error' do
        get :show, params: { id: user.id }
        expect_auth_to_fail
      end
    end

    describe 'POST create' do
      let(:user_params) do
        {
          username: 'harryp',
          fullname: 'harry potter',
          email: 'harryp@gmail.com',
          password: 'new_password'
        }
      end

      it 'creates an user' do
        expect do
          post :create, params: { user: user_params }
        end.to change { User.count }.by(1)
        new_user = User.last
        expect(new_user).to have_attributes(user_params.except!(:password))
      end

      it 'returns the user in the response' do
        post :create, params: { user: user_params }
        new_user = User.last
        expect(response_body).to eq(new_user.decorate.as_json)
      end
    end

    describe 'PUT update' do
      it 'returns an error' do
        get :show, params: { id: user.id }
        expect_auth_to_fail
      end
    end

    describe 'DELETE delete' do
      it 'returns the user with the right id' do
        get :show, params: { id: user.id }
        expect_auth_to_fail
      end
    end

    describe 'POST follow' do
      it 'returns an error' do
        post :follow, params: { followee_id: second_user.id }
        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      request.headers['Authorization'] = "Bearer #{token}"
    end

    describe 'GET show' do
      it 'returns the user with the right id' do
        get :show, params: { id: user.id }
        expect(response_body).to eq(user.decorate.as_json)
      end
    end

    describe 'PUT create' do
      let(:update_user_params) do
        HashWithIndifferentAccess.new({
                                        username: 'harryp',
                                        fullname: 'harry potter',
                                        email: 'harryp@gmail.com'
                                      })
      end

      it 'updates an user' do
        put :update, params: { id: user.id, user: update_user_params }
        user.reload
        expect(user).to have_attributes(update_user_params.except!(:password))

        expect(response_body).to include(update_user_params)
      end
    end

    describe 'DELETE destroy' do
      it 'creates an user' do
        delete :destroy, params: { id: user.id }
        expect(User.exists?(id: user.id)).to be_falsey
      end

      it 'returns the user in the response' do
        delete :destroy, params: { id: user.id }
        expect(response_body).to eq(user.decorate.as_json)
      end
    end

    describe 'POST follow' do
      it 'updates the user to follow another user' do
        post :follow, params: { followee_id: second_user.id }

        user.reload
        second_user.reload

        expect(user.followees).to include(second_user)
        expect(second_user.followers).to include(user)
      end
    end
  end
end
