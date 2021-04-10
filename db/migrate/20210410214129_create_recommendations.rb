# frozen_string_literal: true

class CreateRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendations do |t|
      t.belongs_to :picture
      t.belongs_to :room

      t.timestamps
    end
  end
end
