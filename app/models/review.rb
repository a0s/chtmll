# create_table :reviews, force: :cascade do |t|
#   t.text :comment, null: false
#   t.datetime :created_at, precision: 6, null: false
#   t.datetime :updated_at, precision: 6, null: false
#   t.index [:comment], name: :index_reviews_on_comment
# end

class Review < ApplicationRecord
  has_many :review_themes
  has_many :themes, through: :review_themes
end
