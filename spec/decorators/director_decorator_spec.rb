# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectorDecorator, type: :decorator do
  let!(:director) { create(:director) }
  let!(:decorated_director) { director.decorate }

  it 'delegates the right fields' do
    expect(decorated_director.fullname).to eq(director.fullname)
  end

  describe 'DirectorDecorator#as_json' do
    let!(:director_json) { HashWithIndifferentAccess.new(decorated_director.as_json) }
    let!(:expected_director_hash) do
      HashWithIndifferentAccess.new(
        id: director.id,
        fullname: director.fullname,
        created_at: director.created_at.as_json,
        updated_at: director.updated_at.as_json
      )
    end

    it 'converts to json properly' do
      expect(director_json).to eq(expected_director_hash)
    end
  end
end
