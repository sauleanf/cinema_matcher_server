# frozen_string_literal: true

class FriendshipDecorator < Draper::Decorator
  delegate :id, :first_user, :second_user, :created_at, :updated_at
  decorates_association :first_user, with: UserDecorator
  decorates_association :second_user, with: UserDecorator

  def as_json(options = nil)
    super.merge(first_user: first_user.as_json, second_user: second_user.as_json)
  end
end
