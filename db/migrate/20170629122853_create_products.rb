class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.binary :image, null: false
      t.integer :price, null: false
      t.text :description, null: false
      t.boolean :hidden, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
