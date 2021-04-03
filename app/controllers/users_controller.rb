class UsersController < ApplicationController
  before_action :user, only: %i[ show update destroy ]

  def show
    if user
      render json: user.decorate, status: :ok
    else
      render json: {}, status: :not_found
    end
  end

  def create
    @user = User.new(create_user_params)
    user.password = create_user_params.fetch(:password)

    if @user.save
      render json: user.decorate, status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def update
    user.assign_attributes(user_params)

    if @user.save
      render json: UserDecorator.decorate(user), status: :ok
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user.destroy
    render json: user.decorate, status: :ok
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :fullname)
  end

  def create_user_params
    params.require(:user).permit(:username, :email, :fullname, :password)
  end
end
