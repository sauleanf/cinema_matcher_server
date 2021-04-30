# frozen_string_literal: true

class CreateRecommendationsJob < ApplicationJob
  queue_as :default

  def perform(room)
    recommendations = room.create_recommendations
    decorated_recommendations = RecommendationDecorator.decorate_collection(recommendations).as_json
    RoomChannel.broadcast_to(room, recommendations: decorated_recommendations)
  end
end
