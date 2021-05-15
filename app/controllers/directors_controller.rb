# frozen_string_literal: true

class DirectorsController < ApplicationController
  before_action :directors, only: %i[index]
  before_action :director, only: %i[show]

  def index
    render json: {
      directors: DirectorDecorator.decorate_collection(@directors),
      page: page,
      count: directors.total_count
    }, status: :ok
  end

  def show
    render json: {
      director: @director.decorate
    }, status: :ok
  end

  private

  def directors
    @directors = if filter_params.values.size
                   Director.where(filter_params).page(page)
                 else
                   Director.page(page)
                 end
  end

  def director
    @director = Director.find(params[:id])
  end

  def page
    @page = Integer(params.fetch(:page))
  end

  def filter_params
    params.permit(:fullname)
  end
end
