# frozen_string_literal: true

require 'csv'

class PictureSeeder
  def self.add_picture(row)
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
  end

  def self.seed(destroy_all: true)
    Picture.destroy_all if destroy_all

    CSV.read('imdb.csv', headers: true).each do |row|
      add_picture(row)
    end
  end
end
