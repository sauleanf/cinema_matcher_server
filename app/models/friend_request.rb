# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :other_user, class_name: 'User'

  validates :user, presence: true
  validates :other_user, presence: true
  validate :request_not_reflexive
  validates :user, uniqueness: { scope: :other_user }

  module Status
    ACCEPTED = 'accepted'
    PENDING = 'pending'
    REJECTED = 'rejected'
    RESCINDED = 'rescinded'
  end

  def request_not_reflexive
    errors.add(:other_user, 'Cannot friend themself') if user == other_user
  end

  def accepted?
    status == Status::ACCEPTED
  end

  def pending?
    status == Status::PENDING
  end

  def rejected?
    status == Status::REJECTED
  end

  def rescinded?
    status == Status::RESCINDED
  end
end
