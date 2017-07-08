class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :cod_fee, null: false
      t.integer :ship_fee, null: false
      t.string :ship_to_name, null: false
      t.string :ship_to_address, null: false
      t.date :ship_date, null: false
      t.string :ship_period, null: false
      t.float :tax_rate, null: false, default: 0.08

      t.timestamps
    end

    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
