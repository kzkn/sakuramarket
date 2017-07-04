class AddLockVersionToCart < ActiveRecord::Migration[5.1]
  def change
    add_column :carts, :lock_version, :integer, null: false, default: 0
  end
end
