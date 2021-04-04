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

  describe 'FeatureSet#set_genere' do
    it 'sets the genre to true based on arg' do
      feature_set.set_genre(:drama)
      expect(feature_set.drama).to be(true)
    end
  end
end
