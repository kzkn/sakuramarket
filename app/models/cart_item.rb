class CartItem < ApplicationRecord
  belongs_to :cart, touch: true
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :price, numericality: { only_integer: true, greater_than: 0 }
  validates :product_id, uniqueness: { scope: :cart_id }
  validates :name, presence: true

  def order
    OrderItem.new(product: product, name: name, quantity: quantity, price: price)
  end

  def subtotal
    quantity * price
  end

  def product=(product)
    super
    self.price = product.price unless self.price
    self.name = product.name unless self.name
  end
end
