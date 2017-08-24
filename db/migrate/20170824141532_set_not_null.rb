class SetNotNull < ActiveRecord::Migration[5.1]
  def change
    change_column_null(:line_items, :order_id, false)
    change_column_null(:line_items, :product_id, false)
    change_column_null(:orderings, :user_id, false)
    change_column_null(:orderings, :order_id, false)
    change_column_null(:products, :position, false)
    change_column_null(:purchases, :order_id, false)
  end
end
