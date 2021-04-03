class CreateFeatureSets < ActiveRecord::Migration[6.1]
  def change
    create_table :feature_sets do |t|
      t.references :parent, polymorphic: true

      t.timestamps
    end

    add_reference :features, :feature_set, index: true
  end
end
