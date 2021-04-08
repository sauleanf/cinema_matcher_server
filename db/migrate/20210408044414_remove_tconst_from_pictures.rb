# frozen_string_literal: true

class RemoveTconstFromPictures < ActiveRecord::Migration[6.1]
  def change
    remove_column :pictures, :tconst
  end
end
