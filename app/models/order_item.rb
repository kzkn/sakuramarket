# -*- coding: utf-8 -*-
class OrderItem < ApplicationRecord
  belongs_to :order
  has_one :product_ordering
  has_one :product, through: :product_ordering

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, uniqueness: { scope: :order_id }
  validates :name, presence: true

  def subtotal
    quantity * price
  end
end
