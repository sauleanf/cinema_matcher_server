FactoryBot.define do
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