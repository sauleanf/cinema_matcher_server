# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecommendationDecorator, type: :decorator do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third_user) { create(:user) }

  let!(:room) { Room.create(users: [user, other_user]) }
  let!(:pictures) do
    5.times.map { create(:picture) }
  end
  let!(:recommendation) { room.create_recommendations.first }
  let!(:decorated_recommendation) { recommendation.decorate }

  it 'delegates the right fields' do
    expect(decorated_recommendation.id).to eq(recommendation.id)
  end

  it 'decorates the associations' do
    expect(decorated_recommendation.picture).to be_decorated
  end

  describe 'RecommendationDecorator#as_json' do
    let!(:recommendation_json) { HashWithIndifferentAccess.new(decorated_recommendation.as_json) }
    let!(:expected_recommendation_hash) do
      HashWithIndifferentAccess.new(
        id: recommendation.id,
        created_at: recommendation.created_at.as_json,
        updated_at: recommendation.updated_at.as_json,
        picture: recommendation.picture.decorate.as_json
      )
    end

    it 'converts to json properly' do
      expect(recommendation_json).to eq(expected_recommendation_hash)
    end
  end
end
