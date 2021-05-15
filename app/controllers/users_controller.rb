# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized?, only: %i[index edit friends]

  def index
    render json: current_user.decorate, status: :ok
  end

  def all
    render json: {
      users: UserDecorator.decorate_collection(User.all),
      page: page,
      count: users.total_count
    }, status: :ok
  end

  def create
    @user = User.new(create_user_params)
    @user.password = create_user_params.fetch(:password)

    if @user.save
      Registration.create(user: @user)
      token = JsonWebToken.encode(user_id: @user.id)

      RegistrationMailer.with(user: @user).welcome_email.deliver_later

      render json: { user: @user.decorate, token: token }
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

  def friends
    render json: UserDecorator.decorate_collection(current_user.friends), status: :ok
  end

  private

  def users
    @users = User.page(page)
  end

  def page
    params[:page] || 1
  end

  def user_params
    params.permit(:username, :email, :fullname)
  end

  def create_user_params
    params.permit(:username, :email, :fullname, :password)
  end
end
