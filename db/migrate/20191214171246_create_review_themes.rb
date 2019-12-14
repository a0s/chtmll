class CreateReviewThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :review_themes do |t|
      t.references :theme, foreign_key: true, null: false
      t.references :review, foreign_key: true, null: false
      t.integer :sentiment, null: false
      t.timestamps
    end

    # FIXME: Skip duplications?
    # add_index :review_themes, [:theme_id, :review_id], unique: true
  end
end
