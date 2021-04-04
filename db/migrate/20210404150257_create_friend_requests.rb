# frozen_string_literal: true

class CreateFriendRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :friend_requests do |t|
      t.integer :user_id
      t.integer :other_user_id

      t.timestamps
    end
  end
end
