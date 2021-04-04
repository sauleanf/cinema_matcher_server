# frozen_string_literal: true

class CreateRoomUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :room_users do |t|
      t.belongs_to :room
      t.belongs_to :user

      t.timestamps
    end
  end
end
