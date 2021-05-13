# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authorized?
  before_action :users, only: %i[add create]
  before_action :room, only: %i[show add]

  def index
    render json: RoomDecorator.decorate_collection(current_user.rooms)
  end

  def show
    render json: @room.decorate
  end

  def add
    @room.users += @users

    if @room.save
      render json: @room.decorate, status: :ok
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

      render json: @room.decorate, status: :ok
    else
      render json: @room.errors, status: :unprocessable_entity
    end
  end

  private

  def room
    @room = current_user.rooms.find(params[:id])
  end

  def users
    @users = User.where(id: room_params[:users])
  end

  def room_params
    params.permit(:id, :name, users: [])
  end
end
