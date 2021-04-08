# frozen_string_literal: true

require 'csv'

class PictureSeeder
  def self.seed(destroy_all: true)
    if destroy_all
      Picture.destroy_all
      puts 'Destroy all previous pictures'
      puts '=' * 60
    end

    CSV.read('imdb.csv', headers: true).each do |row|
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
      features.parent = picture

      features.save!

      puts "Inserted #{row['name']} into the database"
    end

    puts '=' * 60
    puts 'Added all pictures from IMDB'
  end
end
