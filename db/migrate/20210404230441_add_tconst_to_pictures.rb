class AddTconstToPictures < ActiveRecord::Migration[6.1]
  def change
    add_column :pictures, :tconst, :string, unique: true
  end
end
