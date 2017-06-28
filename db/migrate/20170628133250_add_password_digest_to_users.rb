class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
    remove_columns :users, :hashed_password, :salt
    DeliveryDestination.delete_all
    User.delete_all
  end
end
