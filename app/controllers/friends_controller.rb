# frozen_string_literal: true

class FriendsController < ApplicationController
  before_action :authorized?, only: %i[index]
  before_action :friends, only: %i[index]

  include PaginationHelper

  def index
    render json: {
      friends: UserDecorator.decorate_collection(@friends)
    }, status: :ok
  end

  private

  def filter_params
    @filter_params ||= [:fullname]
  end

  def friends
    @friends = paginate_record(@current_user.friends)
  end
end
