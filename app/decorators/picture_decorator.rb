# frozen_string_literal: true

class PictureDecorator < Draper::Decorator
  delegate_all
  decorates_associations :directors, with: DirectorDecorator

  def as_json(options = nil)
    HashWithIndifferentAccess.new(super.merge(directors: directors.as_json))
  end
end
