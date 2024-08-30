class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    # 商品購入機能実装時に有効にする
    # create_table :addresses do |t|
    #   t.string :postal_code
    #   t.integer :prefecture_id
    #   t.string :city
    #   t.string :street_address
    #   t.string :building
    #   t.string :phone_number
    #   t.references :order, null: false, foreign_key: true
    #
    #   t.timestamps
    # end
  end
end