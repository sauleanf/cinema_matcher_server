# frozen_string_literal: true

class RecommendationUser < ApplicationRecord
  belongs_to :recommendation
  belongs_to :user
end
