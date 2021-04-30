# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RecommendationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/recommendations').to route_to('recommendations#index')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/recommendations').to route_to('recommendations#create')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/recommendations/1').to route_to('recommendations#show', id: '1')
    end
  end
end
