# frozen_string_literal: true

class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users

  has_many :interested_users
  has_many :recommendations

  def create_recommendations
    Picture.first(4).map do |picture|
      Recommendation.create(room: self, picture: picture)
    end
  end
end
