# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureSetDecorator, type: :decorator do
  let!(:room) { Room.create }
  let!(:feature_set) { create(:feature_set, parent: room) }
  let(:decorated_feature_set) { feature_set.decorate }

  it 'delegates the right fields' do
    FeatureSet::FEATURES.each do |genre|
      expect(decorated_feature_set.send(genre)).to be(feature_set.get_feature(genre))
    end
  end
end
