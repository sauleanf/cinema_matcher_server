# frozen_string_literal: true

class RecommendationsController < ApplicationController
  before_action :authorized?, only: %i[index show create]
  before_action :room, only: %i[index show create]
  before_action :recommendations, only: %i[index]
  before_action :recommendation, only: %i[show]

  def index
    render json: RecommendationDecorator.decorate_collection(@recommendations), status: :ok
  end

  def show
    render json: @recommendation.decorate, status: :ok
  end

  def create
    @recommendations = @room.create_recommendations
    render json: RecommendationDecorator.decorate_collection(@recommendations), status: :ok
  end

  private

  def recommendations
    @recommendations = @room.recommendations
  end

  def recommendation
    @recommendation = @room.recommendations.find(params.fetch(:id))
  end

  def room
    @room = RoomUser.find_by(room_id: room_id,
                             user_id: current_user.id).room
  end

  def room_id
    params.fetch(:room)
  end
end
