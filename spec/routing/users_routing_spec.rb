# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/users').to route_to('users#index')
    end

    it 'routes to #create' do
      expect(post: '/api/v1/users').to route_to('users#create')
    end

    it 'routes to #edit' do
      expect(put: '/api/v1/users/edit').to route_to('users#edit')
    end

    it 'routes to #friends' do
      expect(get: '/api/v1/users/friends').to route_to('users#friends')
    end
  end
end
