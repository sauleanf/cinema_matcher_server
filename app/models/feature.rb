class Feature < ApplicationRecord
  module Types
    DRAMA = "drama"
    ACTION = "action"
    COMEDY = "comedy"
    SCIFI = "sci-fi"
    HORROR = "horror"
    ROMANCE = "romance"
    THRILLER = "thriller"
    FANTASY = "fantasy"
  end

  validates :feature_type, inclusion: { in: Feature::Types.constants.map { |c|  Feature::Types.const_get c } }
end