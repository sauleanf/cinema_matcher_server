# frozen_string_literal: true

class PictureDecorator < Draper::Decorator
  delegate :id, :name, :description, :image, :created_at, :updated_at, :released_at
  decorates_associations :directors, with: DirectorDecorator

  def as_json(options = nil)
    HashWithIndifferentAccess.new(super.merge(directors: directors.as_json))
  end
end
