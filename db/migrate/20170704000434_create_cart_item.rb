class CreateCartItem < ActiveRecord::Migration[5.1]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :price_yen, null: false
    end

    add_foreign_key :cart_items, :carts, on_delete: :cascade
  end
end
