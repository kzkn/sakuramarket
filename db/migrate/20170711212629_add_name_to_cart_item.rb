class AddNameToCartItem < ActiveRecord::Migration[5.1]
  def up
    add_column :cart_items, :name, :string
    transaction do
      CartItem.all.each do |item|
        item.update(name: item.product.name)
      end
    end

    change_column_null :cart_items, :name, false
  end

  def down
    remove_column :cart_items, :name
  end
end
