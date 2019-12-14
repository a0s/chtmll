# create_table :categories, force: :cascade do |t|
#   t.text :name, null: false
#   t.datetime :created_at, precision: 6, null: false
#   t.datetime :updated_at, precision: 6, null: false
# end

class Category < ApplicationRecord
  has_many :themes
end
