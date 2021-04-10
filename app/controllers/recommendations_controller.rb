# frozen_string_literal: true

class RecommendationsController < ApplicationController
  before_action :authorized?, only: %i[index show create update]
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

  def update
    @recommendation.users << interested_user
    @recommendation.save!

    render json: @recommendation.decorate, status: :ok
  end

  private

  def recommendations
    @recommendations = @room.recommendations
  end

  def recommendation
    @recommendation = @room.recommendations.where(id: params.fetch(:recommendation_id))
  end

  def room
    @room = RoomUser.find_by(room_id: room_id,
                             user_id: current_user.id).room
  end

  def interested_user
    params.fetch(:interested_user_id)
  end

  def room_id
    params.fetch(:room_id)
  end
end
