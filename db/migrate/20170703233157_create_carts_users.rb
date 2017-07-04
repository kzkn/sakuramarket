class CreateCartsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :carts_users do |t|
      t.references :user, null: false
      t.references :cart, null: false
      t.timestamps
    end

    add_foreign_key :carts_users, :users, on_delete: :cascade
    add_foreign_key :carts_users, :carts, on_delete: :cascade
  end
end
