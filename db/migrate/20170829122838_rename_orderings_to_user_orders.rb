class RenameOrderingsToUserOrders < ActiveRecord::Migration[5.1]
  def change
    rename_table :orderings, :user_orders
  end
end
