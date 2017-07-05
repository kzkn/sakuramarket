class DropDeliveryDestinations < ActiveRecord::Migration[5.1]
  def change
    drop_table :delivery_destinations
    add_column :users, :delivery_destination_name, :string, null: false, default: ''
    add_column :users, :delivery_destination_address, :string, null: false, default: ''
  end
end
