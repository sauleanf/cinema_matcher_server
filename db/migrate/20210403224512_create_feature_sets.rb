# frozen_string_literal: true

class CreateFeatureSets < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_sets do |t|
      t.references :parent, polymorphic: true
      t.boolean :adult
      t.boolean :action
      t.boolean :adventure
      t.boolean :animation
      t.boolean :comedy
      t.boolean :crime
      t.boolean :documentary
      t.boolean :drama
      t.boolean :fantasy
      t.boolean :horror
      t.boolean :mystery
      t.boolean :romance
      t.boolean :scifi
      t.boolean :sport
      t.boolean :superhero
      t.boolean :thriller

      t.integer :year
      t.integer :length

      t.timestamps
    end
  end
end
