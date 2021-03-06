# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }

  describe 'validate' do
    it 'does not allow reflexive friendships' do
      friendship = Friendship.new(first_user: user, second_user: user)

      expect(friendship.valid?).to be(false)
    end

    it 'does not allow for duplicates' do
      Friendship.create(first_user: user, second_user: second_user)
      duplicate = Friendship.new(first_user: user, second_user: second_user)

      expect(duplicate.valid?).to be(false)
    end
  end
end
