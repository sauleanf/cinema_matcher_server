# frozen_string_literal: true

FactoryBot.define do
  factory :director do
    fullname { 'Stephen Baker' }
  end

  factory :feature_set do
    action { true }
    adventure { true }
    animation { false }
    comedy { false }
    crime { false }
    drama { false }
    fantasy { false }
    horror { true }
    mystery { true }
    romance { false }
    scifi { true }
    superhero { false }
    thriller { false }

    rating { 6.8 }
    year { 2017 }
    length { 221 }
  end

  factory :picture do
    name { 'Dark Knight' }
    description { 'The criminals of Gotham City are running scared' }
    image { 'dark_night.png' }

    released_at { DateTime.now }

    after(:create) do |picture, _evaluator|
      create_list(:director, 2, pictures: [picture])

      picture.reload
    end
  end

  factory :user do
    fullname { 'John Doe' }
    sequence :email do |n|
      "john_doe_#{n}@gmail.com"
    end
    sequence :username do |n|
      "john_doe_#{n}"
    end
    hashed_password { 'placeholder' }
  end
end
