# frozen_string_literal: true

class Director < ApplicationRecord
  has_many :director_sets, dependent: :destroy
  has_many :pictures, through: :director_sets
end
