# frozen_string_literal: true

class PicturesController < ApplicationController
  before_action :pictures, only: %i[index]
  before_action :picture, only: %i[show]

  include PaginationHelper

  def index
    render json: {
      pictures: PictureDecorator.decorate_collection(@pictures),
      page: page,
      count: @pictures.total_count
    }, status: :ok
  end

  def show
    render json: {
      picture: @picture.decorate
    }, status: :ok
  end

  private

  def pictures
    @pictures = paginate_record(Picture)
  end

  def picture
    @picture = Picture.find(params[:id])
  end

  def filter_params
    @filter_params ||= [:name]
  end
end
