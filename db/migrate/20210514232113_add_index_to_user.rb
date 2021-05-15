# frozen_string_literal: true

class AddIndexToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users, bulk: true do |t|
      t.string :username, null: false, unique: true
      t.string :email, null: false, unique: true
    end

    add_index :users, :email, unique: true
  end
end
