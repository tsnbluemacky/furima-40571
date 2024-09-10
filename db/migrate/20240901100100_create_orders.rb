class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :item, foreign_key: true # ここにitem_idを追加
      t.references :user, foreign_key: true # ここにitem_idを追加

      t.timestamps
    end
  end
end