# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DirectorDecorator, type: :decorator do
  let!(:director) { create(:director) }
  let!(:decorated_director) { director.decorate }

  it 'delegates the right fields' do
    expect(decorated_director.fullname).to eq(director.fullname)
  end

  it 'decorates the associations' do
    expect(decorated_director.pictures).to be_decorated
  end
end
