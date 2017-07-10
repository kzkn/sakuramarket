class CreateDeliveryDestinations < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_destinations do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :address, null: false

      t.timestamps
    end
  end
end
