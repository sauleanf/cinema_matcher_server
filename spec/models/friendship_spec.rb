# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { create(:user) }

  describe 'validate' do
    it 'does not allow reflexive friendships' do
      friendship = Friendship.new(first_user: user, second_user: user)

      expect(friendship.valid?).to be(false)
    end
  end
end
