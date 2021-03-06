# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PicturesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/pictures').to route_to('pictures#index')
    end

    it 'routes to #show' do
      expect(get: '/api/v1/pictures/1').to route_to('pictures#show', id: '1')
    end
  end
end
