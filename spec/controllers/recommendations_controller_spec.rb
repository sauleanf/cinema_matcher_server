# frozen_string_literal: true

require 'rails_helper'

describe RecommendationsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:third_user) { create(:user) }

  let!(:room) { Room.create(users: [user, other_user]) }
  let!(:pictures) { 5.times.map { create(:picture) } }
  let!(:recommendations) { room.create_recommendations }
  let!(:recommendation) { recommendations.first }

  context 'when not authenticated' do
    describe 'GET index' do
      it 'returns an error' do
        get :index

        expect_auth_to_fail
      end
    end

    describe 'GET show' do
      it 'returns an error' do
        get :show, params: { id: 1 }

        expect_auth_to_fail
      end
    end

    describe 'POST create' do
      it 'returns an error' do
        post :create

        expect_auth_to_fail
      end
    end
  end

  context 'when authenticated' do
    before do
      login_user user
    end

    describe 'GET index' do
      it 'returns recommendations for the room' do
        get :index, params: { room: room.id }

        expect(response_body[:items]).to eq(RecommendationDecorator
                                                        .decorate_collection(recommendations)
                                                        .as_json)
      end
    end

    describe 'GET show' do
      it 'returns recommendations for the room' do
        get :show, params: { room: room.id, id: recommendation.id }

        expect(response_body[:item]).to eq(recommendation.decorate.as_json)
      end
    end

    describe 'POST create' do
      let(:new_recommendations) { room.create_recommendations }

      it 'returns the new recommendations for the room' do
        expect_any_instance_of(Room).to receive(:create_recommendations).and_return(new_recommendations)

        post :create, params: { room: room.id }

        expect(response_body[:items].pluck(:id)).to eq(new_recommendations.pluck(:id))
      end
    end
  end
end
