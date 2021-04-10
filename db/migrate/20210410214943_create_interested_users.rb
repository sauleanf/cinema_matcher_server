# frozen_string_literal: true

class CreateInterestedUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :interested_users do |t|
      t.belongs_to :recommendation
      t.belongs_to :user

      t.timestamps
    end
  end
end
