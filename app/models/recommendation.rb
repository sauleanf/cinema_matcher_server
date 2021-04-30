# frozen_string_literal: true

class Recommendation < ApplicationRecord
  belongs_to :room
  belongs_to :picture

  has_many :recommendation_users, dependent: :destroy
  has_many :users, through: :interested_users

  has_many :recommendation_statuses, dependent: :destroy

  def confirm!(user)
    @status = recommendation_status_for_user(user)
    @status.update!(confirmed: true)
  end

  def reject!(user)
    @status = recommendation_status_for_user(user)
    @status.update!(confirmed: false)
  end

  private

  def recommendation_status_for_user(user)
    RecommendationStatus.find_or_create_by(user: user,
                                           recommendation: self)
  end
end
