# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authorized?
  before_action :users, only: %i[add create]
  before_action :room, only: %i[show add]
  before_action :rooms, only: %i[index]

  def index
    render json: {
      rooms: RoomDecorator.decorate_collection(@rooms),
      count: current_user.rooms.count,
      page: page
    }, status: :ok
  end

  def show
    render json: {
      room: @room.decorate
    }, status: :ok
  end

  def add
    @room.users += @users

    if @room.save
      render json: {
        room: @room.decorate
      }, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  def create
    @room = Room.new(name: params[:name])
    @room.users = users
    @room.users << current_user

    if @room.save
      CreateRecommendationsJob.perform_later(@room)

      render json: {
        room: @room.decorate
      }, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  private

  def filter_params
    params.permit(:name)
  end

  def room
    @room = current_user.rooms.find(params[:id])
  end

  def rooms
    @rooms = if filter_params.values.size
               current_user.rooms.where(filter_params).page(page)
             else
               current_user.rooms.page(page)
             end
  end

  def users
    @users = User.where(id: room_params[:users])
  end

  def room_params
    params.permit(:id, :name, users: [])
  end

  def page
    params[:page] || 1
  end
end
