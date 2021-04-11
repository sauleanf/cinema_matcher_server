# frozen_string_literal: true

class RoomDecorator < Draper::Decorator
  delegate :id, :created_at, :updated_at
  decorates_associations :users, with: UserDecorator

  def as_json(options = nil)
    super.merge(users: users.as_json)
  end
end
