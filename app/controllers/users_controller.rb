# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized?, only: %i[show update destroy follow]

  def show
    render json: current_user.decorate, status: :ok
  end

  def follow
    followee_id = params[:followee_id]
    followee = User.find(followee_id)
    current_user.follow(followee_id)

    render json: followee.decorate, status: :ok
  end

  def create
    @user = User.new(create_user_params)
    @user.password = create_user_params.fetch(:password)

    if @user.save
      render json: @user.decorate, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def update
    current_user.assign_attributes(user_params)

    if current_user.save
      render json: current_user.decorate, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.destroy
    render json: current_user.decorate, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :fullname)
  end

  def create_user_params
    params.require(:user).permit(:username, :email, :fullname, :password)
  end
end
