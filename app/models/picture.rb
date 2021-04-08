# frozen_string_literal: true

class Picture < ApplicationRecord
  has_many :director_sets, dependent: :destroy
  has_many :directors, through: :director_sets
  has_one :feature_set, as: :parent, dependent: :destroy

  delegate :set_feature, to: :features

  def features
    if feature_set
      @features = feature_set
    else
      @features = FeatureSet.create(parent: self) unless feature_set
    end
  end
end
