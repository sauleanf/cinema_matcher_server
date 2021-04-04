# frozen_string_literal: true

class PictureDecorator < Draper::Decorator
  delegate_all
  decorates_associations :directors
end
