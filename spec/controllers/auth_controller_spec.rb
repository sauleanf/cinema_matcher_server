# frozen_string_literal: true

require 'rails_helper'

describe AuthController, type: :controller do
  let(:password) { 'password2' }
  let(:user) { create(:user, password: password) }

  describe 'POST login' do
    it 'returns the user and token' do
      post :login, params: { email: user.email, password: password }

      expect(response_body.key?(:token)).to be_truthy
      expect(response_body[:user]).to eq(user.decorate.as_json)
    end

    context 'when authentication fails' do
      let(:error_res) do
        HashWithIndifferentAccess.new({ password: Messages::WRONG_CREDENTIALS })
      end

      it 'returns a message and 401' do
        post :login, params: { email: user.email, password: 'wrong' }

        expect(response.status).to eq(401)
        expect(response_body).to eq(error_res)
      end
    end

    context 'when the user does not exist' do
      let(:error_res) do
        HashWithIndifferentAccess.new({ email: Messages::USER_NOT_FOUND })
      end

      it 'returns a message and 401' do
        post :login, params: { email: 'wrong', password: 'wrong' }

        expect(response.status).to eq(401)
        expect(response_body).to eq(error_res)
      end
    end
  end
end
