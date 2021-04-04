# frozen_string_literal: true

class FeatureSet < ApplicationRecord
  GENERES = %i[
    adult
    action
    adventure
    animation
    comedy
    crime
    documentary
    drama
    fantasy
    horror
    mystery
    romance
    scifi
    sport
    superhero
    thriller
  ].freeze

  belongs_to :parent, polymorphic: true
end
