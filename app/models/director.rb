class Director < ApplicationRecord
  has_many :director_sets
  has_many :pictures, through: :director_sets
end
