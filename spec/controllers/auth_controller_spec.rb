# frozen_string_literal: true

require 'rails_helper'

describe AuthController, type: :controller do
  let(:password) { 'password2' }
  let(:user) do
    user = create(:user)
    user.password = password
    user.save!

    user
  end

  describe 'POST login' do
    it 'returns the user and token' do
      post :login, params: { credentials: { email: user.email, password: password } }

      body = JSON.parse(response.body)

      expect(body.key?('token')).to be_truthy
      expect(body['user'].to_json).to eq(user.decorate.to_json)
    end

    context 'when authentication fails' do
      it 'returns a message and 401' do
        post :login, params: { credentials: { email: user.email, password: 'wrong' } }

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)).to eq('msg' => 'Credential are wrong')
      end
    end
  end
end
