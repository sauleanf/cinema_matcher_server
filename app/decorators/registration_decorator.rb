# frozen_string_literal: true

class RegistrationDecorator < Draper::Decorator
  delegate :id, :code
end
