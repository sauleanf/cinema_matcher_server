# frozen_string_literal: true

class RecommendationsController < ApplicationController
  before_action :authorized?, only: %i[index show create]
  before_action :room, only: %i[index show create]
  before_action :recommendations, only: %i[index]
  before_action :recommendation, only: %i[show]

  include PaginationHelper

  def index
    render_records(@recommendations)
  end

  def show
    render_record(@recommendation)
  end

  def create
    @recommendations = @room.create_recommendations
    render json: {
      items: @recommendations.decorate
    }, status: :ok
  end

  private

  def recommendations
    @recommendations = paginate_record(@room.recommendations)
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
