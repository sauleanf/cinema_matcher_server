# frozen_string_literal: true

class DirectorsController < ApplicationController
  before_action :directors, only: %i[index]
  before_action :director, only: %i[show]

  include PaginationHelper

  FILTER_PARAMS = [:fullname].freeze

  def index
    render_records(@directors)
  end

  def show
    render_record(@director)
  end

  private

  def directors
    @directors = paginate_record(Director, FILTER_PARAMS)
  end

  def director
    @director = Director.find(params[:id])
  end
end
