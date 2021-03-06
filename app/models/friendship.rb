# frozen_string_literal: true

class Friendship < ApplicationRecord
  belongs_to :first_user, class_name: 'User', dependent: :destroy
  belongs_to :second_user, class_name: 'User', dependent: :destroy

  validates :first_user, presence: true
  validates :second_user, presence: true
  validate :friendship_not_reflexive
  validates :first_user, uniqueness: { scope: :second_user }

  def friendship_not_reflexive
    errors.add(:second_user, 'Cannot friend themself') if first_user == second_user
  end
end
