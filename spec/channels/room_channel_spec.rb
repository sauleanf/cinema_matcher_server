# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomChannel, type: :channel do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:room) { Room.create(users: [user, second_user]) }
  let!(:num_pictures) { 5 }
  let!(:pictures) { num_pictures.times.map { create(:picture) } }
  let!(:recommendations) { room.create_recommendations }

  before do
    stub_connection room: room
    subscribe
  end

  context 'when not all recommendations have been reviewed' do
    it 'does nothing' do
      expect do
        perform(:receive, {
                  user_id: user.id,
                  recommendation_id: recommendations.first.id,
                  confirmed: true
                })
      end.not_to have_broadcasted_to(room).from_channel(RoomChannel)
    end
  end

  context 'when all recommendations have been reviewed' do
    let!(:confirmed_recommendations) { recommendations.first(3) }
    let!(:rejected_recommendations) { recommendations - confirmed_recommendations }

    before do
      recommendations.map do |recommendation|
        recommendation.confirm!(second_user)
        recommendation.confirm!(user)
      end

      rejected_recommendations.map do |recommendation|
        recommendation.reject!(user)
      end
    end

    it 'broadcasts to the entire room' do
      decorated_recommendations = RecommendationDecorator.decorate_collection(confirmed_recommendations)
      expect do
        perform(:receive, {
                  user_id: user.id,
                  recommendation_id: recommendations.first.id,
                  confirmed: true
                })
      end.to have_broadcasted_to(room)
        .from_channel(RoomChannel)
        .with(confirmed_recommendations: decorated_recommendations.as_json)
    end
  end
end
