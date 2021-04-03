class RoomsController < ApplicationController
  before_action :authorized?

  def index
    render json: current_user.rooms
  end

  def show
    render json: current_user.rooms.find(params[:id])
  end

  def create
    user_ids = params[:room][:user_ids]
    users = User.where(id: user_ids)
    room = Room.new
    room.users = users

    if room.save
      render json: room.decorate, status: :ok
    else
      render json: room.errors, status: :unprocessable_entity
    end
  end

  private

  def create_room_params
    params.require(:room).permit(:user_ids)
  end
end
