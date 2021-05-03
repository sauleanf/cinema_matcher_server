# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized?, only: %i[index edit]

  def index
    render json: current_user.decorate, status: :ok
  end

  def create
    @user = User.new(create_user_params)
    @user.password = create_user_params.fetch(:password)

    if @user.save
      Registration.create(user: @user)

      RegistrationMailer.with(user: @user).welcome_email.deliver_later

      render json: @user.decorate, status: :ok
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def edit
    current_user.assign_attributes(user_params)

    if current_user.save
      render json: current_user.decorate, status: :ok
    else
      render json: current_user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :fullname)
  end

  def create_user_params
    params.require(:user).permit(:username, :email, :fullname, :password)
  end
end
