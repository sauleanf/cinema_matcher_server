# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PictureDecorator, type: :decorator do
  let(:picture) { create(:picture) }
  let(:decorated_picture) { picture.decorate }

  it 'delegates the right fields' do
    expect(decorated_picture.id).to eq(picture.id)
    expect(decorated_picture.description).to eq(picture.description)
    expect(decorated_picture.image).to eq(picture.image)
    expect(decorated_picture.released_at).to eq(picture.released_at)
  end

  it 'decorates the associations' do
    expect(decorated_picture.directors).to be_decorated
  end

  describe 'PictureDecorator#as_json' do
    let!(:picture_json) { HashWithIndifferentAccess.new(decorated_picture.as_json) }
    let!(:expected_picture_hash) do
      HashWithIndifferentAccess.new(
        id: picture.id,
        image: picture.image,
        name: picture.name,
        description: picture.description,
        created_at: picture.created_at.as_json,
        updated_at: picture.updated_at.as_json,
        released_at: picture.released_at.as_json,
        directors: DirectorDecorator.decorate_collection(picture.directors).as_json
      )
    end

    it 'converts to json properly' do
      expect(picture_json).to eq(expected_picture_hash)
    end
  end
end
