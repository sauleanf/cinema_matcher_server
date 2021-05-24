# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :authorized?, only: %i[show]
  before_action :friend_request, only: %i[show]

  def show
    render_record(@friend_request)
  end

  private

  def friend_request
    @friend_request = FriendRequest.find(params[:id])
  end
end
