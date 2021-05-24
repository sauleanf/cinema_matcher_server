# frozen_string_literal: true

class PicturesController < ApplicationController
  before_action :pictures, only: %i[index]
  before_action :picture, only: %i[show]

  include PaginationHelper

  FILTER_PARAMS = [:name].freeze

  def index
    render_records(@pictures)
  end

  def show
    render_record(@picture)
  end

  private

  def pictures
    @pictures = paginate_record(Picture, FILTER_PARAMS)
  end

  def picture
    @picture = Picture.find(params[:id])
  end
end
