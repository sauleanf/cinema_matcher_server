# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index

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

    describe 'PUT edit' do
      it 'returns an error' do
        put :edit

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET index' do
      it 'returns the user with the right id' do
        get :index

        expect(response_body).to eq(user.decorate.as_json)
      end
    end

    describe 'PUT create' do
      let(:edit_user_params) do
        {
          username: 'harryp',
          fullname: 'harry potter',
          email: 'harryp@gmail.com'
        }
      end

      it 'edits an user' do
        put :edit, params: { user: edit_user_params }

        user.reload

        expect(user).to have_attributes(edit_user_params.except!(:password))
        expect(response_body).to include(edit_user_params)
      end
    end
  end
end
