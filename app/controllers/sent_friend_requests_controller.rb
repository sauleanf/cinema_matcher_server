# frozen_string_literal: true

class SentFriendRequestsController < ApplicationController
  before_action :authorized?, only: %i[index create rescind]
  before_action :friend_request, only: %i[rescind]
  before_action :friend_requests, only: %i[index]
  before_action :other_user, only: %i[create]

  def index
    render json: FriendRequestDecorator.decorate_collection(friend_requests), status: :ok
  end

  def create
    data = current_user.send_friend_request(@other_user)

    if data.key?(:error)
      render json: data.fetch(:error), status: :unprocessable_entity
    else
      render json: data.fetch(:friend_request).decorate, status: :ok
    end
  end

  def rescind
    @friend_request.status = FriendRequest::Status::RESCINDED
    @friend_request.save!
    render json: friend_request.decorate, status: :ok
  end

  private

  def other_user
    @other_user = User.find(friend_request_params[:other_user_id])
  end

  def friend_requests
    @friend_requests = current_user.sent_pending_friend_requests
  end

  def friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def friend_request_params
    params.require(:request).permit(:other_user_id)
  end
end
