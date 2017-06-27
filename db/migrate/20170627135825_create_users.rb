class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :hashed_password, null: false
      t.string :salt, null: false
      t.timestamps
    end

    add_index :users, :email_address, unique: true
  end
end
