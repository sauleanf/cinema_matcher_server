# frozen_string_literal: true

class CreateFollowings < ActiveRecord::Migration[6.1]
  def change
    create_table :followings do |t|
      t.integer :followee_id
      t.integer :follower_id

      t.timestamps
    end

    add_index(:followings, %i[followee_id follower_id], unique: true)
  end
end
