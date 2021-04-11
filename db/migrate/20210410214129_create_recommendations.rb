# frozen_string_literal: true

class CreateRecommendations < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendations do |t|
      t.integer :picture_id
      t.integer :room_id

      t.timestamps
    end
  end
end
