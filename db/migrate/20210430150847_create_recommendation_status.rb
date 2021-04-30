# frozen_string_literal: true

class CreateRecommendationStatus < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendation_statuses do |t|
      t.belongs_to :recommendation
      t.belongs_to :user
      t.boolean :confirmed

      t.timestamps
    end
  end
end
