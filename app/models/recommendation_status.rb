# frozen_string_literal: true

class RecommendationStatus < ApplicationRecord
  belongs_to :recommendation
  belongs_to :user
end
