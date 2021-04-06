# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authorized?
  before_action :users, only: %i[add]
  before_action :room, only: %i[show add]

  def index
    render json: current_user.rooms
  end

  def show
    render json: room.decorate
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
    room = Room.new
    room.users << current_user

    if room.save
      render json: room.decorate, status: :ok
    else
      render json: room.errors, status: :unprocessable_entity
    end
  end

  private

  def room
    @room = current_user.rooms.find(params[:id])
  end

  def users
    @users = User.where(id: room_params[:user_ids])
  end

  def room_params
    params.require(:room).permit(:id, user_ids: [])
  end
end
