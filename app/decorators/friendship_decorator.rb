# frozen_string_literal: true

class FriendshipDecorator < Draper::Decorator
  delegate_all
  decorates_association :first_user
  decorates_association :second_user, with: UserDecorator
end
