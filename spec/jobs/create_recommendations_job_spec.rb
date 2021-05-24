# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateRecommendationsJob, type: :job do
  let(:user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:room) { Room.create(users: [user, second_user]) }
  let!(:pictures) { 10.times.map { create(:picture) } }
  let!(:recommendations) { room.create_recommendations }
  let!(:decorated_recommendations) { RecommendationDecorator.decorate_collection(recommendations).as_json }
  let!(:message_body) do
    {
      foo: 'bar',
      enqueued_at: '2021-05-20T15:11:36Z'
    }
  end
  let!(:sqs_params) do
    {
      message_body: JSON.generate(message_body)
    }
  end

  before do
    ActiveJob::Base.queue_adapter = :test
    allow_any_instance_of(Room).to receive(:create_recommendations).and_return(recommendations)
    allow_any_instance_of(ApplicationJob).to receive(:sqs_send_message_parameters).and_return(sqs_params)
  end

  describe '#perform_later' do
    it 'enqueues a job' do
      expect do
        CreateRecommendationsJob.perform_later(room)
      end.to have_enqueued_job
    end

    it 'enqueues a job' do
      expect do
        CreateRecommendationsJob.perform_now(room)
      end.to have_broadcasted_to(room).from_channel(RoomChannel).with(
        type: RoomChannel::Types::CREATE_RECOMMENDATIONS,
        payload: decorated_recommendations
      )
    end
  end
end
