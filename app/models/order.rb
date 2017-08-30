class Order < ApplicationRecord
  class CheckoutError < StandardError; end

  has_many :items, class_name: "LineItem", dependent: :destroy
  has_one :user_order, dependent: :destroy
  has_one :user, through: :user_order
  has_one :purchase

  scope :only_checked, -> { joins(:purchase) }
  scope :only_cart, -> { left_outer_joins(:purchase).where(purchases: { id: nil }) }

  def self.get_or_create_cart_for(current_user)
    return current_user.cart if current_user&.cart
    return current_user.orders.create if current_user
    Order.create
  end

  def merge_or_assign(user)
    if user.cart
      move_items_to(user.cart)
    else
      update!(user: user)
      self
    end
  end

  def move_items_to(other)
    transaction do
      items.each { |item| other.add_item(item.product, item.quantity, item.price) }
      destroy!
    end

    other
  end

  def cart?
    purchase.nil?
  end

  def add_item(product, quantity, price = nil)
    return if quantity <= 0

    price ||= product.price
    item = items.find_by(product_id: product.id, price: price)
    if item
      item.quantity += quantity
    else
      item = items.build(product: product, quantity: quantity, price: price)
    end
    item.save
  end

  def subtotal
    items.sum(&:subtotal)
  end

  def total_quantity
    items.sum(&:quantity)
  end
end
