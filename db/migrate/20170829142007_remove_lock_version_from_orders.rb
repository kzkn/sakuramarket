class RemoveLockVersionFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :lock_version
  end
end
