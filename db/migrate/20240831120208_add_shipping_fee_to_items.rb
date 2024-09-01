class AddShippingFeeToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :shipping_fee, :integer
  end
end
