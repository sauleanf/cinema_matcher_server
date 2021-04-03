class CreateFeatures < ActiveRecord::Migration[6.1]
  def change
    create_table :features do |t|
      t.string :feature_type
      t.float :datum
    end
  end
end
