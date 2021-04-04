class DirectorsController < ApplicationController
  def index

    decorated_directors = DirectorDecorator.decorate_collection(directors)
    render json: {
      directors: decorated_directors,
      page: page,
      count: directors.total_count
    }, status: :ok
  end

  def show
    render json: director.decorate, status: :ok
  end

  private

  def directors
    @directors = Director.page(page)
  end

  def director
    @directors = Director.find(params[:id])
  end

  def page
    params.fetch(:page)
  end
end
