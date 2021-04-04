class Picture < ApplicationRecord
  has_many :director_sets
  has_many :directors, through: :director_sets
end
