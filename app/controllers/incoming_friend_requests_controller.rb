# frozen_string_literal: true

class IncomingFriendRequestsController < ApplicationController
  before_action :authorized?, only: %i[index show accept reject]
  before_action :incoming_friend_requests, only: %i[index]
  before_action :incoming_friend_request, only: %i[show accept reject]

  include PaginationHelper

  def index
    render_records(@incoming_friend_requests)
  end

  def show
    render_record(@incoming_friend_request)
  end

  def accept
    data = current_user.accept_friend_request(incoming_friend_request)

    if data.key?(:error)
      render json: data.fetch(:error), status: :unprocessable_entity
    else
      render_record(data.fetch(:friendship))
    end
  end

  def reject
    @incoming_friend_request.update(status: FriendRequest::Status::REJECTED)
    render_record(@incoming_friend_request)
  end

  private

  def incoming_friend_request
    @incoming_friend_request = current_user.incoming_pending_friend_requests.find(params[:id])
  end

  def incoming_friend_requests
    @incoming_friend_requests = paginate_record(current_user.incoming_pending_friend_requests)
  end
end
