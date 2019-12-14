class CreateThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :themes do |t|
      t.references :category, foreign_key: true, null: false
      t.text :name, null: false
      t.timestamps
    end
  end
end
