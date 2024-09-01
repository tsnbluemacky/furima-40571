class AddShippingFeeIdToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :shipping_fee_id, :integer
  end
end
