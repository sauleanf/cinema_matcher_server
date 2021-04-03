class FeatureSetDecorator < Draper::Decorator
  delegate_all
  decorates_associations :features, with: FeatureDecorator
end