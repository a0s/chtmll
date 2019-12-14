# create_table :review_themes, force: :cascade do |t|
#   t.bigint :theme_id, null: false
#   t.bigint :review_id, null: false
#   t.integer :sentiment, null: false
#   t.datetime :created_at, precision: 6, null: false
#   t.datetime :updated_at, precision: 6, null: false
#   t.index [:review_id], name: :index_review_themes_on_review_id
#   t.index [:theme_id], name: :index_review_themes_on_theme_id
# end

class ReviewTheme < ApplicationRecord
  belongs_to :review
  belongs_to :theme
end
