# frozen_string_literal: true

class RoomsController < ApplicationController
  before_action :authorized?

  def index
    render json: current_user.rooms
  end

  def show
    render json: current_user.rooms.find(params[:id])
  end

  def add
    room = Room.find(params[:id])
    room.users += new_users

    if room.save
      render json: room.decorate, status: :ok
    else
      render json: room.errors, status: :unprocessable_entity
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

  def new_users
    User.where(id: room_params[:user_ids])
  end

  def room_params
    params.require(:room).permit(:id, user_ids: [])
  end
end
