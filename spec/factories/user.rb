FactoryBot.define do
    factory :user do
      name { Faker::Name.name }
      age { rand(0..150) }
      email { Faker::Internet.email }
    end
end
  