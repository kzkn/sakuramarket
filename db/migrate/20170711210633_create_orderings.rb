class CreateOrderings < ActiveRecord::Migration[5.1]
  def change
    create_table :orderings do |t|
      t.references :user
      t.references :order
    end
  end
end
