class RemoveUserIdFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :user_id
  end
end
