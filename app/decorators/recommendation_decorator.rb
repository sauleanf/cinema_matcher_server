# frozen_string_literal: true

class RecommendationDecorator < Draper::Decorator
  decorates_association :picture, with: PictureDecorator
  decorates_association :user, with: UserDecorator
end
