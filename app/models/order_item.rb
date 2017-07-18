class OrderItem < ApplicationRecord
  belongs_to :order
  has_one :product_ordering
  has_one :product, through: :product_ordering

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  # TODO create 時にはチェックしたい
  # validates :product_id, uniqueness: { scope: :order_id }
  validates :name, presence: true

  def product=(product)
    super
    self.price = product.price unless self.price
    self.name = product.name unless self.name
  end

  def subtotal
    quantity * price
  end
end
