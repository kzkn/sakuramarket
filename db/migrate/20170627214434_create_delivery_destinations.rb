# -*- coding: utf-8 -*-
class CreateDeliveryDestinations < ActiveRecord::Migration[5.1]
  def change
    create_table :delivery_destinations do |t|
      t.references :user, null: false  # TODO 外部キー制約がつかない
      t.string :name, null: false
      t.string :address, null: false

      t.timestamps
    end
  end
end
