# frozen_string_literal: true

class SentFriendRequestsController < ApplicationController
  before_action :authorized?, only: %i[index create rescind]
  before_action :friend_request, only: %i[rescind]
  before_action :friend_requests, only: %i[index]
  before_action :other_user, only: %i[create]

  include PaginationHelper

  def index
    render_records(@friend_requests)
  end

  def show
    render_record(@friend_request)
  end

  def create
    data = current_user.send_friend_request(@other_user)

    if data.key?(:error)
      render json: data.fetch(:error), status: :unprocessable_entity
    else
      render_record(data.fetch(:friend_request))
    end
  end

  def rescind
    @friend_request.status = FriendRequest::Status::RESCINDED
    @friend_request.save!
    render json: {
      sent_friend_request: friend_request.decorate
    }, status: :ok
  end

  private

  def other_user
    @other_user = User.find(friend_request_params[:other_user])
  end

  def friend_requests
    @friend_requests = paginate_record(current_user.sent_pending_friend_requests)
  end

  def friend_request
    @friend_request = FriendRequest.find(params[:id])
  end

  def friend_request_params
    params.permit(:other_user)
  end
end
