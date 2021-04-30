# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRecommendationsJob, type: :job do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:room) { Room.create(users: [user, second_user]) }
  let!(:pictures) { 10.times.map { create(:picture) } }
  let!(:recommendations) { room.create_recommendations }
  let!(:decorated_recommendations) { RecommendationDecorator.decorate_collection(recommendations).as_json }

  before do
    allow_any_instance_of(Room).to receive(:create_recommendations).and_return(recommendations)
  end

  describe '#perform_later' do
    it 'enqueues a job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        CreateRecommendationsJob.perform_later(room)
      end.to have_enqueued_job
    end

    it 'enqueues a job' do
      ActiveJob::Base.queue_adapter = :test
      expect do
        CreateRecommendationsJob.perform_now(room)
      end.to have_broadcasted_to(room).from_channel(RoomChannel).with(recommendations: decorated_recommendations)
    end
  end
end
