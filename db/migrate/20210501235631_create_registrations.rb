# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[6.1]
  def change
    create_table :registrations do |t|
      t.belongs_to :user, unique: true
      t.integer :code

      t.timestamp :confirmed_at
      t.timestamps
    end
  end
end
