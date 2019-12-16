FactoryBot.define do
  factory :review do
    comment { Faker::Lorem.sentence(word_count: 1, random_words_to_add: 11) }

    trait :deep do
      after :create do |review|
        create_list :review_theme, 1, review: review
      end
    end
  end
end
