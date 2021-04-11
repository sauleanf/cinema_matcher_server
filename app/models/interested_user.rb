# frozen_string_literal: true

class InterestedUser < ApplicationRecord
  belongs_to :recommendation
  belongs_to :user
end
