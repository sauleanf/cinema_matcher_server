class RoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validate :user, presence: true
  validate :room, presence: true
end
