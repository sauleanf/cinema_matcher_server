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

  FEATURES = FeatureSet::GENERES + %i[
    year
    length
    rating
  ]

  belongs_to :parent, polymorphic: true

  def set_feature(feature, val)
    send("#{feature}=", val)
  end

  def get_feature(feature)
    send(feature)
  end
end
