FactoryBot.define do
  factory :review_theme do
    sentiment { [-1, 0, 1].sample }
    theme
  end
end
