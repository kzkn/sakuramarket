class SetOnDeleteCascadeForDeliveryDestinationUserId < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :delivery_destinations, column: :user_id
    add_foreign_key :delivery_destinations, :users, on_delete: :cascade
  end
end
