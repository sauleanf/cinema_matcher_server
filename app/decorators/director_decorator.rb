class DirectorDecorator < Draper::Decorator
  delegate_all
  decorates_associations :pictures, with: PictureDecorator
end
