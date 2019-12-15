FactoryBot.define do
  factory :theme do
    name { Faker::Lorem.word }
    category
  end
end
