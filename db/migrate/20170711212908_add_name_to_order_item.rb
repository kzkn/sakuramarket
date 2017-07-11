class AddNameToOrderItem < ActiveRecord::Migration[5.1]
  def up
    add_column :order_items, :name, :string
    transaction do
      OrderItem.all.each do |item|
        item.update(name: item.product.name)
      end
    end

    change_column_null :order_items, :name, false
  end

  def down
    remove_column :order_items, :name
  end
end
