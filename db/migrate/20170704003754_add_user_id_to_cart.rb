class AddUserIdToCart < ActiveRecord::Migration[5.1]
  def change
    add_column :carts, :user_id, :integer
    add_foreign_key :carts, :users, on_delete: :cascade
    drop_table :carts_users
  end
end
