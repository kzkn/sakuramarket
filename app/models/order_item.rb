class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  def subtotal
    quantity * price
  end
end
