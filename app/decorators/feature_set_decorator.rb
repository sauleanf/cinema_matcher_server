# frozen_string_literal: true

class FeatureSetDecorator < Draper::Decorator
  delegate :id, *FeatureSet::GENERES, :year, :length, :created_at, :updated_at, :rating
end
