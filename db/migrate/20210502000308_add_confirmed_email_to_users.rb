# frozen_string_literal: true

class AddConfirmedEmailToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :confirmed_email, :boolean, default: false
  end
end
