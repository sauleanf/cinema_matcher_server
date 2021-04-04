# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate :id, :fullname, :email, :username, :profile_image, :created_at, :updated_at
end
