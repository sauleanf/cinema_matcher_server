# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authorized?
  before_action :users, only: %i[add create]
  before_action :room, only: %i[show add]
  before_action :rooms, only: %i[index]

  include PaginationHelper

  FILTER_PARAMS = [:name].freeze

  def index
    render_records(@rooms)
  end

  def show
    render_record(@room)
  end

  def add
    @room.users += @users

    if @room.save
      render_record(@room)
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def create
    @room = Room.new(name: new_room_name)
    @room.users = users
    @room.users << current_user

    if @room.save
      CreateRecommendationsJob.perform_later(@room)

      render_record(@room)
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  private

  def new_room_name
    params[:name] || 'My Room'
  end

  def room
    @room = current_user.rooms.find(params[:id])
  end

  def rooms
    @rooms = paginate_record(current_user.rooms, FILTER_PARAMS)
  end

  def users
    @users = User.where(id: room_params[:users])
  end

  def room_params
    params.permit(:id, :name, users: [])
  end
end
