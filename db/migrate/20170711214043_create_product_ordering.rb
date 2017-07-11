class CreateProductOrdering < ActiveRecord::Migration[5.1]
  def up
    create_table :product_orderings do |t|
      t.references :product, foreign_key: true
      t.references :order_item, foreign_key: true
    end

    transaction do
      OrderItem.all.each do |item|
        ProductOrdering.create(order_item: item, product: item.product)
      end
    end
  end

  def down
    drop_table :product_orderings
  end
end
