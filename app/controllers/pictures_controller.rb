# frozen_string_literal: true

class PicturesController < ApplicationController
  def index
    decorated_pictures = PictureDecorator.decorate_collection(pictures)
    render json: {
      pictures: decorated_pictures,
      page: page,
      count: pictures.total_count
    }, status: :ok
  end

  def show
    render json: picture.decorate, status: :ok
  end

  private

  def pictures
    @pictures = Picture.page(page)
  end

  def picture
    @picture = Picture.find(params[:id])
  end

  def page
    params.fetch(:page)
  end
end
