# -*- coding: utf-8 -*-
class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, uniqueness: { scope: :order_id }

  def subtotal
    quantity * price
  end
end
