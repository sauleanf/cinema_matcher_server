# frozen_string_literal: true

require 'rails_helper'

describe PicturesController, type: :controller do
  let(:num_pages) { 3 }
  let(:per_page) { 25 }
  let(:num_pictures) { per_page * num_pages }
  let!(:first_page_pictures) { per_page.times.map { create(:picture) } }
  let!(:second_page_pictures) { per_page.times.map { create(:picture) } }
  let!(:third_page_pictures) { per_page.times.map { create(:picture) } }
  let!(:pages_of_pictures) do
    [
      first_page_pictures,
      second_page_pictures,
      third_page_pictures
    ]
  end

  describe 'GET index' do
    it 'returns pages' do
      page = 0

      num_pages.times.each do |i|
        page = i + 1

        get :index, params: { page: page }

        pictures = PictureDecorator.decorate_collection(pages_of_pictures[i])
        received_pictures = response_body.fetch(:pictures)

        expect(received_pictures.size).to eq(per_page)
        expect(received_pictures).to eq(pictures.as_json)
      end

      expect(page).to eq(num_pages)
    end

    context 'when a filter param is passed' do
      let!(:name) { 'New Movie' }
      let!(:filtered_picture) do
        picture = create(:picture)
        picture.update(name: name)
        picture
      end
      let!(:expected_res) do
        HashWithIndifferentAccess.new({
                                        pictures: PictureDecorator.decorate_collection([filtered_picture]).as_json,
                                        count: 1,
                                        page: 1
                                      })
      end

      it 'returns the filtered pages' do
        get :index, params: { page: 1, name: name }

        expect(response_body).to eq(expected_res)
      end
    end
  end

  describe 'GET show' do
    let!(:picture) { first_page_pictures.first }

    it 'returns an error' do
      get :show, params: { id: picture.id }

      expect(response_body[:picture]).to eq(picture.decorate.as_json)
    end
  end
end
