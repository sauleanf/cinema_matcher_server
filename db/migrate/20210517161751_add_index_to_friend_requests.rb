# frozen_string_literal: true

class AddIndexToFriendRequests < ActiveRecord::Migration[6.1]
  def change
    add_index :friend_requests, %i[user_id other_user_id], unique: true
  end
end
