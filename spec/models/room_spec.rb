# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let!(:num_pictures) { 5 }
  let!(:pictures) { num_pictures.times.map { create(:picture) } }
  let(:room) { Room.create(users: [user, second_user]) }
  let!(:recommendations) { room.create_recommendations }
  let!(:confirmed_recommendations) { recommendations.first(3) }
  let!(:rejected_recommendations) { recommendations - confirmed_recommendations }

  def view_recommendations
    recommendations.map do |recommendation|
      recommendation.confirm!(second_user)
      recommendation.confirm!(user)
    end

    rejected_recommendations.map do |recommendation|
      recommendation.reject!(user)
    end

    room.recommendations.reload
  end

  before do
    user.reload
    second_user.reload
    room.reload
    room.recommendations.reload
  end

  describe '#users' do
    it 'shows the users in the room' do
      expect(room.users).to include(user)
      expect(room.users).to include(second_user)
    end
  end

  describe '#confirmed_recommendations' do
    before do
      view_recommendations
      user.reload
      second_user.reload
      room.reload
      room.recommendations.reload
    end

    it 'returns the confirmed recommendations' do
      expect(room.confirmed_recommendations).to eq(confirmed_recommendations)
    end
  end

  describe '#completed?' do
    context 'when the recommendations have not been viewed' do
      it 'returns false' do
        expect(room.completed?).to be(false)
      end
    end

    context 'when the recommendations have been viewed' do
      before do
        view_recommendations
      end
      it 'returns false' do
        expect(room.completed?).to be(true)
      end
    end
  end
end
