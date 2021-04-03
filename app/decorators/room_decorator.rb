class RoomDecorator < Draper::Decorator
  delegate_all
  decorates_associations :users, with: UserDecorator
end