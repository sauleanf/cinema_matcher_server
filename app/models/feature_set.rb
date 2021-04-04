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
    sbkrt
    sport
    superhero
    thriller
  ].freeze

  belongs_to :parent, polymorphic: true

  def set_genre(genre)
    self.send("#{genre.to_s}=", true)
  end
end
