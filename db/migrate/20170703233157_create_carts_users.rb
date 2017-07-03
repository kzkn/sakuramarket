class CreateCartsUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :carts_users do |t|
      t.references :user, null: false, foreign_key: true
      t.references :cart, null: false, foreign_key: true

      t.timestamps
    end
  end
end
