# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :first_user, class_name: 'User', foreign_key: :first_user_id, dependent: :destroy
  belongs_to :second_user, class_name: 'User', foreign_key: :second_user_id, dependent: :destroy

  validates :first_user, presence: true
  validates :second_user, presence: true
  validate :friendship_not_reflexive

  def friendship_not_reflexive
    errors.add(:other_user, 'Cannot friend themself') if first_user == second_user
  end
end
