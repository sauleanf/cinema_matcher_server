require 'rails_helper'

RSpec.describe FeatureSet, type: :model do
  let!(:parent) { Room.create }
  let!(:feature_set) { create(:feature_set, parent: parent) }

  it "has a field for each of the genres" do
    FeatureSet::GENERES.each do |genre|
      expect(feature_set).to respond_to(genre)
    end
  end
end
