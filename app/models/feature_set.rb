class FeatureSet < ApplicationRecord
  GENERES = [
    :action,
    :adventure,
    :animation,
    :comedy,
    :crime,
    :drama,
    :fantasy,
    :horror,
    :mystery,
    :romance,
    :scifi,
    :superhero,
    :thriller,
  ]

  belongs_to :parent, polymorphic: true
end