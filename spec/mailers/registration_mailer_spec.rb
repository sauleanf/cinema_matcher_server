# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationMailer, type: :mailer do
  let!(:user) { create(:user) }
  let!(:registration) { Registration.create(user: user) }

  describe 'welcome_email' do
    let(:mail) { described_class.with(user: user).welcome_email.deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to Cinema Matcher')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the registration code' do
      expect(mail.body.encoded)
        .to match(registration.code.to_s)
    end

    it 'renders the user fullname' do
      expect(mail.body.encoded)
        .to match(user.fullname.to_s)
    end
  end

  describe 'confirmed_email' do
    let(:mail) { described_class.with(user: user).confirmed_email.deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Email Address Confirmed!')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end
  end
end
