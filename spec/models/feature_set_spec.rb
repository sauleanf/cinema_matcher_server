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

  describe 'FeatureSet#get_genere and FeatureSet#set_genre' do
    it 'gets and sets the genre' do
      FeatureSet::GENERES.map do |genre|
        feature_set.set_genre(genre, false)
        expect(feature_set.get_genre(genre)).to be(false)

        feature_set.set_genre(genre)
        expect(feature_set.get_genre(genre)).to be(true)
      end
    end
  end
end
