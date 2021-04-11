# frozen_string_literal: true

class FriendRequestDecorator < Draper::Decorator
  delegate :id, :user, :other_user, :created_at, :updated_at, :status
  decorates_association :user, with: UserDecorator
  decorates_association :other_user, with: UserDecorator

  def as_json(options = nil)
    super.merge(user: user.as_json, other_user: other_user.as_json)
  end
end
