class CreateReviews < ActiveRecord::Migration[6.0]
  def change
    create_table :reviews do |t|
      t.text :comment, null: false, index: true
      t.timestamps
    end
  end
end
