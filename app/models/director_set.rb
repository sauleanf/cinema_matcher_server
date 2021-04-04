# frozen_string_literal: true

class DirectorSet < ApplicationRecord
  belongs_to :director
  belongs_to :picture
end
