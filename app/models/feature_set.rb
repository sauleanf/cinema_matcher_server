class FeatureSet < ApplicationRecord
  belongs_to :parent, polymorphic: true
  has_many :features
end