# frozen_string_literal: true

class RecommendationDecorator < Draper::Decorator
  delegate :id, :picture, :created_at, :updated_at
  decorates_association :picture, with: PictureDecorator

  def as_json(options = nil)
    HashWithIndifferentAccess.new(super.merge(picture: picture.as_json))
  end
end
