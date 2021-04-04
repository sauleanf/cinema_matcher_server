# frozen_string_literal: true

require 'csv'

class PictureSeeder
  def self.seed(destroy_all = true)
    if destroy_all
      Picture.destroy_all
      puts 'Destroy all previous pictures'
      puts '=' * 60
    end

    imdb_pictures = File.open('data.tsv').read

    index = 0
    imdb_pictures.each_line do |line|
      if index.positive?

        row = line.split("\t")

        tconst = row[0]
        genres = row[8].split(',')
                       .map { |genre| genre.strip.downcase.to_sym }
                       .filter { |genre| FeatureSet::GENERES.include? genre }
        name = row[2]
        genres << :adult unless (row[4]).nil?
        year = row[5].to_i
        released_at = DateTime.new(year)

        picture = Picture.create(tconst: tconst, name: name, released_at: released_at)

        features = FeatureSet.new
        features.year = year
        features.parent = picture

        genres.map do |genre|
          features.set_genre(genre)
        end

        features.save!

        puts "Add picture #{name}"
      end

      index += 1
    end

    puts '=' * 60
    puts 'Added all pictures from IMDB'
  end
end

PictureSeeder.seed
