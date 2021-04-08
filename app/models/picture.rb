# frozen_string_literal: true

class Picture < ApplicationRecord
  has_many :director_sets
  has_many :directors, through: :director_sets
  has_one :feature_set, as: :parent

  def set_feature(feature, datum)
    features.set_feature(feature, datum)
  end

  def features
    if feature_set
      @features = feature_set
    else
      @features = FeatureSet.create(parent: self) unless feature_set
    end
  end
end
