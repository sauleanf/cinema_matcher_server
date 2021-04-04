# frozen_string_literal: true

class DirectorDecorator < Draper::Decorator
  delegate_all
  decorates_associations :pictures, with: PictureDecorator
end
