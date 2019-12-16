class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :comment

  has_many :review_themes, key: :themes

  class ReviewThemeSerializer < ActiveModel::Serializer
    attributes :sentiment, :theme_id
  end
end
