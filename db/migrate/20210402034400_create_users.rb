# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :fullname
      t.string :profile_image
      t.string :username

      t.string :hashed_password

      t.timestamps
    end
  end
end
