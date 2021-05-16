# frozen_string_literal: true

class FriendsController < ApplicationController
  before_action :authorized?, only: %i[index]
  before_action :friends, only: %i[index]

  include PaginationHelper

  FILTER_PARAMS = %i[fullname username].freeze

  def index
    render_records(@friends)
  end

  private

  def friends
    @friends = paginate_record(@current_user.friends, FILTER_PARAMS)
  end
end
