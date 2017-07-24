class Init < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password_digest, null: false
      t.string :ship_name, null: false, default: ''
      t.string :ship_address, null: false, default: ''
      t.timestamps
    end

    create_table :products do |t|
      t.string :name, null: false
      t.string :image_filename, null: false
      t.integer :price, null: false
      t.text :description, null: false
      t.boolean :hidden, null: false
      t.integer :position
      t.timestamps
    end

    create_table :orders do |t|
      t.integer :lock_version, null: false, default: 0
      t.timestamps
    end

    create_table :orderings do |t|
      t.references :user, foreign_key: true
      t.references :order, foreign_key: true, unique: false
      t.timestamps
    end

    create_table :line_items do |t|
      t.references :order, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :price, null: false
      t.integer :quantity, null: false
      t.timestamps
    end

    add_index :line_items, [:order_id, :product_id, :price], unique: true

    create_table :purchases do |t|
      t.references :order, foreign_key: true, unique: true
      t.float :tax_rate, null: false
      t.integer :cod_cost, null: false
      t.integer :ship_cost, null: false
      t.integer :total, null: false
      t.string :ship_name, null: false
      t.string :ship_address, null: false
      t.date :ship_due_date, null: false
      t.string :ship_due_time, null: false
      t.timestamps
    end
  end
end
