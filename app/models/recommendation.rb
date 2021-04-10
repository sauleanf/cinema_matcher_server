# frozen_string_literal: true

class Recommendation < ApplicationRecord
  belongs_to :room
  belongs_to :picture

  has_many :interested_users
end
