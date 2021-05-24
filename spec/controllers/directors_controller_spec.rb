# frozen_string_literal: true

require 'rails_helper'

describe DirectorsController, type: :controller do
  let(:num_pages) { 3 }
  let(:per_page) { 25 }
  let(:num_directors) { per_page * num_pages }
  let!(:first_page_directors) { per_page.times.map { create(:director) } }
  let!(:second_page_directors) { per_page.times.map { create(:director) } }
  let!(:third_page_directors) { per_page.times.map { create(:director) } }
  let!(:pages_of_directors) do
    [
      first_page_directors,
      second_page_directors,
      third_page_directors
    ]
  end

  describe 'GET index' do
    it 'returns pages' do
      page = 0

      num_pages.times.each do |i|
        page = i + 1

        get :index, params: { page: page }

        directors = DirectorDecorator.decorate_collection(pages_of_directors[i])
        received_directors = response_body.fetch(:items)

        expect(received_directors.size).to eq(per_page)
        expect(received_directors).to eq(directors.as_json)
      end

      expect(page).to eq(num_pages)
    end

    context 'when a filter param is passed' do
      let!(:name) { 'Eric Charles' }
      let!(:filtered_director) do
        Director.create(fullname: name)
      end
      let!(:expected_res) do
        HashWithIndifferentAccess.new({
                                        items: [filtered_director.decorate.as_json],
                                        count: 1,
                                        page: 1
                                      })
      end

      it 'returns the filtered pages' do
        get :index, params: { page: 1, fullname: name }

        expect(response_body).to eq(expected_res)
      end
    end
  end

  describe 'GET show' do
    let!(:director) { first_page_directors.first }

    it 'returns the director' do
      get :show, params: { id: director.id }

      expect(response_body[:item]).to eq(director.decorate.as_json)
    end
  end
end
