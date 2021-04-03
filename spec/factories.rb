FactoryBot.define do
  factory :picture do
    name { "Dark Knight" }
    description { "The criminals of Gotham City are running scared" }
    image { "dark_night.png" }

    released_at { DateTime.now }
  end

  factory :user do
    fullname { "John Doe" }
    sequence :email do |n|
      "john_doe_#{n}@gmail.com"
    end
    sequence :username do |n|
      "john_doe_#{n}"
    end
    hashed_password { "hashed_pw" }
  end
end