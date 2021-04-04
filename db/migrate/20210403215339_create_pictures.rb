# frozen_string_literal: true

class CreatePictures < ActiveRecord::Migration[6.1]
  def change
    create_table :pictures do |t|
      t.string :name
      t.string :description
      t.string :image

      t.datetime :released_at
      t.timestamps
    end
  end
end
