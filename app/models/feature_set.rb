class FeatureSet < ApplicationRecord
  GENERES = [
    :adult,
    :action,
    :adventure,
    :animation,
    :comedy,
    :crime,
    :documentary,
    :drama,
    :fantasy,
    :horror,
    :mystery,
    :romance,
    :scifi,
    :sport,
    :superhero,
    :thriller,
  ]

  belongs_to :parent, polymorphic: true
end