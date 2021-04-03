require 'rails_helper'

RSpec.describe PictureDecorator, type: :decorator do
  let(:picture) { create(:picture) }
  let(:decorated_picture) { picture.decorate }

  it "delegates the right fields" do
    expect(decorated_picture.id).to eq(picture.id)
    expect(decorated_picture.description).to eq(picture.description)
    expect(decorated_picture.image).to eq(picture.image)
    expect(decorated_picture.released_at).to eq(picture.released_at)
  end
end
