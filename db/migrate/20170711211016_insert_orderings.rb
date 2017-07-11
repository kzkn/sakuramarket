class InsertOrderings < ActiveRecord::Migration[5.1]
  def up
    transaction do
      Order.all.each do |order|
        Ordering.create(order: order, user: order.user)
      end
    end
  end

  def down
    Ordering.delete_all
  end
end
