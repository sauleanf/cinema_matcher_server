# frozen_string_literal: true

class FriendRequestDecorator < Draper::Decorator
  delegate_all
  decorates_association :user, with: UserDecorator
  decorates_association :other_user, with: UserDecorator
end
