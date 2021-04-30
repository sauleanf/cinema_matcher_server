# frozen_string_literal: true

class CreateRecommendationUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :recommendation_users do |t|
      t.belongs_to :recommendation
      t.belongs_to :user

      t.timestamps
    end
  end
end
