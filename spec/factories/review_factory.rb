FactoryBot.define do
  factory :review do
    comment { Faker::Lorem.sentence(word_count: 1, random_words_to_add: 11) }
  end
end
