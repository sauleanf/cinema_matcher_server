# frozen_string_literal: true

class AddRatingToFeatureSets < ActiveRecord::Migration[6.1]
  def change
    add_column :feature_sets, :rating, :numeric
  end
end
