# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/rooms').to route_to('rooms#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/rooms/1').to route_to('rooms#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/rooms').to route_to('rooms#create')
    end

    it 'routes to #add' do
      expect(post: '/api/v1/rooms/add').to route_to('rooms#add')
    end
  end
end
