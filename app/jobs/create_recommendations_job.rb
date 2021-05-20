# frozen_string_literal: true

class CreateRecommendationsJob < ApplicationJob
  queue_as 'create_recommendations'

  def perform(room)
    recommendations = room.create_recommendations
    decorated_recommendations = recommendations.decorate.as_json
    RoomChannel.broadcast_to(room, type: RoomChannel::Types::CREATE_RECOMMENDATIONS, payload: decorated_recommendations)
  end
end
