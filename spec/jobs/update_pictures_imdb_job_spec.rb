# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdatePicturesImdbJob, type: :job do
  let!(:s3) { Aws::S3::Client.new(stub_responses: true) }
  let!(:response) do
    {
      body: file_fixture('imdb.csv').read
    }
  end
  let(:pictures_data) { YAML.load_file('spec/support/imdb_pictures.yml')['pictures'] }
  let(:bucket) { 'test_bucket' }
  let(:key) { 'key' }

  before do
    ActiveJob::Base.queue_adapter = :test
    s3.stub_responses(:get_object,
                      lambda { |context|
                        if context.params[:bucket] == bucket && context.params[:key]
                          response
                        else
                          'NoSuchKey'
                        end
                      })
    allow_any_instance_of(UpdatePicturesImdbJob).to receive(:s3).and_return(s3)
  end

  it 'creates the new records' do
    UpdatePicturesImdbJob.perform_now(bucket, key)
    expect(Picture.count).to eq(pictures_data.size)

    Picture.all.each_with_index do |picture, i|
      picture_data = pictures_data[i]
      expect(picture.name).to eq(picture_data['name'])
      expect(picture.description).to eq(picture_data['description'])
      expect(picture.image).to eq(picture_data['image'])
      expect(picture.released_at).to eq(picture_data['released_at'].to_datetime)

      expect(picture.directors.pluck(:fullname)).to eq(picture_data['directors'])

      expect(picture.feature_set.rating).to eq(picture_data['rating'])
      FeatureSet::GENERES.each do |genre|
        expect(picture.feature_set.get_feature(genre)).to eq(picture_data[genre.to_s])
      end
    end
  end
end
