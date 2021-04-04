# frozen_string_literal: true

class RoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :user, presence: true
  validates :room, presence: true
end
