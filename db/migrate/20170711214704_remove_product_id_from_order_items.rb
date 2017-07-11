class RemoveProductIdFromOrderItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :order_items, :product_id
  end
end
