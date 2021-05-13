# frozen_string_literal: true

require 'rails_helper'

describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user) }
  let!(:friendships) do
    friendship = Friendship.create(first_user: user, second_user: second_user)
    symmetric_friendship = Friendship.create(first_user: second_user, second_user: user)
    [friendship, symmetric_friendship]
  end

  before do
    ActiveJob::Base.queue_adapter = :test
  end

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

      it 'creates an user and registration' do
        expect do
          post :create, params: user_params
        end.to change { User.count }.by(1)

        new_user = User.last
        registration = new_user.registration

        expect(new_user).to have_attributes(user_params.except!(:password))
        expect(registration.confirmed?).to eq(false)
      end

      it 'sends an email' do
        expect do
          post :create, params: user_params
        end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      end

      it 'returns the user and token in the response' do
        post :create, params: user_params

        new_user = User.last

        expect(response_body[:user]).to eq(new_user.decorate.as_json)
        expect(response_body.key?(:token)).to be_truthy
      end
    end

    describe 'PUT edit' do
      it 'returns an error' do
        put :edit

        expect_auth_to_fail
      end
    end

    describe 'GET friends' do
      it 'returns an error' do
        get :friends

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
        put :edit, params: edit_user_params

        user.reload

        expect(user).to have_attributes(edit_user_params.except!(:password))
        expect(response_body).to include(edit_user_params)
      end
    end

    describe 'GET friends' do
      it 'returns the second user' do
        get :friends

        expect(response_body).to eq([second_user.decorate.as_json])
      end
    end
  end
end
