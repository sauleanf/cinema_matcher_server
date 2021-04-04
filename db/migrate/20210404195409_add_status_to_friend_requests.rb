# frozen_string_literal: true

class AddStatusToFriendRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :friend_requests, :status, :string, default: 'pending'
  end
end
