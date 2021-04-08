# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FeatureSet, type: :model do
  let!(:parent) { Room.create }
  let!(:feature_set) { create(:feature_set, parent: parent) }

  it 'has a field for each of the genres' do
    FeatureSet::GENERES.each do |genre|
      expect(feature_set).to respond_to(genre)
    end
  end

  describe 'FeatureSet#get_feature and FeatureSet#set_feature' do
    let!(:year) { 2011 }
    let!(:rating) { 3.1 }

    it 'gets and sets the features' do
      FeatureSet::GENERES.map do |genre|
        feature_set.set_feature(genre, false)
        expect(feature_set.get_feature(genre)).to be(false)

        feature_set.set_feature(genre)
        expect(feature_set.get_feature(genre)).to be(true)
      end

      feature_set.set_feature(:year, year)
      expect(feature_set.get_feature(:year)).to eq(year)

      feature_set.set_feature(:rating, rating)
      expect(feature_set.get_feature(:rating)).to eq(rating)
    end
  end
end
