class RenameDeliveryDestinations < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :delivery_destination_name, :ship_to_name
    rename_column :users, :delivery_destination_address, :ship_to_address
  end
end
