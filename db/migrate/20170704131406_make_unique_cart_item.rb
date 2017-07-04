class MakeUniqueCartItem < ActiveRecord::Migration[5.1]
  def change
    add_index :cart_items, [:cart_id, :product_id], unique: true
  end
end
