# frozen_string_literal: true

require 'aws-sdk'
require 'csv'

class UpdatePicturesImdbJob < ApplicationJob
  queue_as 'update_pictures_imdb'

  def perform(*args)
    bucket = args.first
    key = args.second
    response = s3.get_object(bucket: bucket, key: key)

    CSV.parse(response.body, headers: true).each do |row|
      add_picture(row)
    end
  end

  def add_picture(row)
    picture = Picture.create(
      name: row['name'],
      description: row['description'],
      released_at: row['released_at'].to_datetime,
      image: row['image']
    )

    features = FeatureSet.new(parent: picture)
    FeatureSet::GENERES.each { |genre| features.set_feature(genre, row[genre.to_s] == 'True') }
    features.set_feature(:year, picture.released_at.year)
    features.set_feature(:rating, row['rating'].to_f)
    features.save!

    director_names = row[22...row.size]
    director_names.each do |director_name|
      # TODO: account for different directors but with the same name
      director = Director.find_or_create_by(fullname: director_name)
      director.pictures << picture
      director.save!
    end
  end

  def s3
    @s3 ||= Aws::S3::Client.new(
      region: 'us-east-1',
      access_key_id: Rails.application.credentials.config[:aws][:access_key_id],
      secret_access_key: Rails.application.credentials.config[:aws][:secret_access_key]
    )
  end
end
