# frozen_string_literal: true

class AddIndexToFriendships < ActiveRecord::Migration[6.1]
  def change
    add_index :friendships, %i[first_user_id second_user_id], unique: true
  end
end
