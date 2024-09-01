class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true # 購入者に関連付ける外部キー
      t.references :item, null: false, foreign_key: true # 購入された商品に関連付ける外部キー
      t.timestamps
    end
  end
end