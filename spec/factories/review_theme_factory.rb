FactoryBot.define do
  factory :review_theme do
    sentiment { [-1, 0, 1].sample }
    review
    theme
  end
end
