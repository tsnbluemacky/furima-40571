class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :text, null: false
      t.integer :price, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :category_id, null: false
      t.integer :condition_id, null: false
      t.integer :shipping_id, null: false
      t.integer :prefecture_id, null: false
      t.integer :delivery_time_id, null: false

      t.timestamps
    end
  end
end