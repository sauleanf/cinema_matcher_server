# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recommendation, type: :model do
  let(:user) { create(:user) }
  let!(:num_pictures) { 5 }
  let!(:pictures) { num_pictures.times.map { create(:picture) } }
  let(:room) { Room.create(users: [user]) }
  let!(:recommendation) { room.create_recommendations.first }

  before do
    user.reload
    room.reload
    room.recommendations.reload
  end

  describe '#confirm!' do
    it 'creates a new recommendation status and sets it to true' do
      expect do
        recommendation.confirm!(user)
      end.to change { RecommendationStatus.count }.by(1)

      status = RecommendationStatus.find_by(user: user, recommendation: recommendation, confirmed: true)
      expect(status).to be_truthy
    end

    context 'when a recommendation status already exists' do
      let!(:recommendation_status) do
        RecommendationStatus.create(user: user, recommendation: recommendation, confirmed: false)
      end
      it 'updates it' do
        recommendation.confirm!(user)

        status = RecommendationStatus.where(user: user, recommendation: recommendation, confirmed: true)
        expect(status.size).to eq(1)
      end
    end
  end

  describe '#reject!' do
    it 'creates a new recommendation status and sets it to false' do
      expect do
        recommendation.reject!(user)
      end.to change { RecommendationStatus.count }.by(1)

      status = RecommendationStatus.find_by(user: user, recommendation: recommendation, confirmed: false)
      expect(status).to be_truthy
    end

    context 'when a recommendation status already exists' do
      let!(:recommendation_status) do
        RecommendationStatus.create(user: user, recommendation: recommendation, confirmed: true)
      end
      it 'updates it' do
        recommendation.reject!(user)

        status = RecommendationStatus.where(user: user, recommendation: recommendation, confirmed: false)
        expect(status.size).to eq(1)
      end
    end
  end
end
