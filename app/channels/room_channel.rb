# frozen_string_literal: true

class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_for room
  end

  def unsubscribed; end

  def receive(data)
    RecommendationStatus.create(data.slice(:user_id,
                                           :recommendation_id,
                                           :confirmed))
    room.recommendation_statuses.reload

    # checks if every one has either accepted or rejected their recommendations
    return unless room.completed?

    recommendations = room.confirmed_recommendations

    broadcast_to(room, confirmed_recommendations: RecommendationDecorator.decorate_collection(recommendations).as_json)
  end

  private

  def room
    @room ||= Room.find(params[:id])
  end
end
