# frozen_string_literal: true

class AddNameToRooms < ActiveRecord::Migration[6.1]
  def change
    add_column :rooms, :name, :string, default: false
  end
end
