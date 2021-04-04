class CreateDirectionSets < ActiveRecord::Migration[6.1]
  def change
    create_table :director_sets do |t|
      t.integer :director_id
      t.integer :picture_id

      t.timestamps
    end

    add_index(:director_sets, [:director_id, :picture_id], unique: true)
  end
end
