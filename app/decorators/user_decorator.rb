# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate :id, :fullname, :email, :username, :profile_image, :created_at, :updated_at, :registration

  def as_json(options = nil)
    HashWithIndifferentAccess.new(super.merge(registration: registration.decorate.as_json)) unless registration.nil?
    super
  end
end
