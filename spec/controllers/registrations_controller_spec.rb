# frozen_string_literal: true

require 'rails_helper'

describe RegistrationsController, type: :controller do
  let(:user) { create(:user) }
  let!(:registration) { Registration.create(user: user) }

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

    describe 'PUT update' do
      it 'returns an error' do
        put :update

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET index' do
      it 'shows the registration' do
        get :index

        expect(response_body).to eq(registration.decorate.as_json)
      end
    end

    describe 'PUT update' do
      context 'when the code is correct' do
        it 'confirms the user' do
          put :update, params: { code: registration.code }

          user.reload
          expect(user.confirmed_email).to eq(true)

          registration.reload
          expect(registration.confirmed?).to be(true)
        end

        it 'returns a helpful message' do
          put :update, params: { id: registration.id, code: registration.code }

          expect(response_body).to eq(registration.decorate.as_json)
          expect(response).to have_http_status(200)
        end

        it 'enqueues the mailer' do
          expect do
            put :update, params: { code: registration.code }
          end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
        end
      end

      context 'when the code is incorrect' do
        before do
          put :update, params: { code: registration.code + 10 }
        end

        it 'does not confirm the user' do
          user.reload
          expect(user.confirmed_email).to eq(false)

          registration.reload
          expect(registration.confirmed?).to be(false)
        end

        let!(:registration_failed_res) do
          HashWithIndifferentAccess.new({
                                          code: Messages::REGISTRATION_FAILED
                                        })
        end

        it 'returns a helpful message' do
          expect(response_body).to eq(registration_failed_res)
          expect(response).to have_http_status(422)
        end
      end
    end
  end
end
