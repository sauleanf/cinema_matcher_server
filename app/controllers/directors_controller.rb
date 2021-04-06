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
    render json: @director.decorate, status: :ok
  end

  private

  def directors
    @directors = Director.page(page)
  end

  def director
    @director = Director.find(params[:id])
  end

  def page
    params.fetch(:page)
  end
end
