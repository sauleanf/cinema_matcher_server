# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/registrations/1').to route_to('registrations#show', id: '1')
    end

    it 'routes to #update' do
      expect(put: '/api/v1/registrations').to route_to('registrations#update')
    end
  end
end
