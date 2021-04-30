# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  has_many :interested_users, dependent: :destroy
  has_many :recommendations, dependent: :destroy

  has_many :recommendation_statuses, through: :recommendations

  def create_recommendations
    Picture.first(4).map do |picture|
      Recommendation.create(room: self, picture: picture)
    end
  end

  # Checks to see if all recommendations have been considered
  def completed?
    num_recommendations = recommendations.size
    num_users = users.size
    num_confirmed_recommendations = recommendation_statuses.size

    num_users * num_recommendations == num_confirmed_recommendations
  end

  def confirmed_recommendations
    num_users = users.size
    recommendations.eager_load(:recommendation_statuses)
                   .where(recommendation_statuses: { confirmed: true })
                   .filter { |recommendation| recommendation.recommendation_statuses.size == num_users }
  end
end
