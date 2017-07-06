class AddTimestampToCartItem < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :cart_items, null: true

    now = Time.now
    CartItem.update_all(created_at: now, updated_at: now)

    change_column_null :cart_items, :created_at, :updated_at
  end
end
