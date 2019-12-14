# create_table :themes, force: :cascade do |t|
#   t.bigint :category_id, null: false
#   t.text :name, null: false
#   t.datetime :created_at, precision: 6, null: false
#   t.datetime :updated_at, precision: 6, null: false
#   t.index [:category_id], name: :index_themes_on_category_id
# end

class Theme < ApplicationRecord
  belongs_to :category
end
