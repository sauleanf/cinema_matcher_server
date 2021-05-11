# frozen_string_literal: true

class RoomDecorator < Draper::Decorator
  delegate :id, :name, :created_at, :updated_at
  decorates_associations :users, with: UserDecorator

  def as_json(options = nil)
    HashWithIndifferentAccess.new(super.merge(users: users.as_json))
  end
end
