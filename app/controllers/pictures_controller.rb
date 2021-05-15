# frozen_string_literal: true

class PicturesController < ApplicationController
  before_action :pictures, only: %i[index]
  before_action :picture, only: %i[show]

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
    @pictures = if filter_params.values.size
                  Picture.where(filter_params).page(page)
                else
                  Picture.page(page)
                end
  end

  def picture
    @picture = Picture.find(params[:id])
  end

  def filter_params
    params.permit(:name)
  end

  def page
    Integer(params[:page]) || 1
  end
end
