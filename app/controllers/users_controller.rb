# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authorized?, only: %i[index show edit]
  before_action :users, only: [:index]

  include PaginationHelper

  FILTER_PARAMS = %i[fullname username].freeze

  def index
    render_records(@users)
  end

  def show
    render_record(@current_user)
  end

  def create
    @user = User.new(create_user_params)
    @user.password = create_user_params.fetch(:password)

    if @user.save
      Registration.create(user: @user)
      token = JsonWebToken.encode(user_id: @user.id)

      RegistrationMailer.with(user: @user).welcome_email.deliver_later

      render_record(@user, token: token)
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def edit
    current_user.assign_attributes(user_params)

    if current_user.save
      render_record(current_user)
    else
      render json: {
        user: current_user.errors
      }, status: :unprocessable_entity
    end
  end

  private

  def users
    @users = paginate_record(User, FILTER_PARAMS)
  end

  def page
    @page ||= Integer(params[:page] || 1)
  end

  def user_params
    params.permit(:username, :email, :fullname)
  end

  def create_user_params
    params.permit(:username, :email, :fullname, :password)
  end
end
