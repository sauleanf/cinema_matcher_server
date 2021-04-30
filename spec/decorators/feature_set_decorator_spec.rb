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

  describe 'FeatureSetDecorator#as_json' do
    let!(:feature_set_json) { HashWithIndifferentAccess.new(decorated_feature_set.as_json) }
    let!(:expected_feature_set_hash) do
      hash = HashWithIndifferentAccess.new(
        id: decorated_feature_set.id,
        created_at: decorated_feature_set.created_at.as_json,
        updated_at: decorated_feature_set.updated_at.as_json
      )
      FeatureSet::FEATURES.each do |feature|
        hash[feature] = feature_set.get_feature(feature).as_json
      end

      hash
    end

    it 'converts to json properly' do
      expect(feature_set_json).to eq(expected_feature_set_hash)
    end
  end
end
