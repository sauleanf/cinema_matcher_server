# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectorsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/directors').to route_to('directors#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/directors/1').to route_to('directors#show', id: '1')
    end
  end
end
