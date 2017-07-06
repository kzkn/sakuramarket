class CreateIndexOnCartsUserId < ActiveRecord::Migration[5.1]
  def change
    add_index :carts, :user_id, unique: true
  end
end
