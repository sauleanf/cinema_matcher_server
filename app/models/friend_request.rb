# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  module Status
    ACCEPTED = 'accepted'
    PENDING = 'pending'
    REJECTED = 'rejected'
    RESCINDED = 'rescinded'
  end

  belongs_to :user, dependent: :destroy
  belongs_to :other_user, class_name: 'User', foreign_key: :other_user_id, dependent: :destroy

  validates :user, presence: true
  validates :other_user, presence: true
  validate :request_not_reflexive

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

  def accept_request
    status = Status::ACCEPTED
    save!
  end

  def reject_request
    status = Status::REJECTED
    save!
  end

  def rescind_request
    status = Status::RESCINDED
    save!
  end
end
