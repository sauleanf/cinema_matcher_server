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
    short
    sport
    superhero
    thriller
  ].freeze

  belongs_to :parent, polymorphic: true

  def set_genre(genre, val=true)
    send("#{genre}=", val)
  end

  def get_genre(genre)
    send(genre)
  end
end
