class RemoveShippingFeeFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :shipping_fee, :integer
  end
end
