# frozen_string_literal: true

class InterestedUser < ApplicationRecord
  belongs_to :room
  belongs_to :user
end
