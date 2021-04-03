require 'rails_helper'

RSpec.describe FeatureDecorator, type: :decorator do
  let!(:feature) { Feature.create(feature_type: Feature::Types::DRAMA, datum: 1) }
  let(:decorated_feature) { feature.decorate }

  it "delegates the right fields" do
    expect(decorated_feature.feature_type).to eq(Feature::Types::DRAMA)
    expect(decorated_feature.datum).to eq(feature.datum)
  end
end
