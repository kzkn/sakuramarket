class Order < ApplicationRecord
  class CheckoutError < StandardError; end

  has_many :items, class_name: "LineItem", dependent: :destroy
  has_one :ordering, dependent: :destroy
  has_one :user, through: :ordering
  has_one :purchase

  scope :only_checked, -> { joins(:purchase) }
  scope :only_cart, -> { left_outer_joins(:purchase).where(purchases: { id: nil }) }

  def self.ensure_cart_created(current_cart, current_user)
    return current_cart if current_cart
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

  def any_items?
    items.any?
  end

  def add_item(product, quantity, price = nil)
    quantity = quantity.to_i
    return unless quantity > 0

    price ||= product.price

    transaction do
      item = items.find_by(product_id: product.id, price: price)
      if item
        item.quantity += quantity
        item.save
      else
        items.create(product: product, quantity: quantity, price: price)
      end
    end

  rescue ActiveRecord::StaleObjectError
    reload
    add_item(product, quantity, price) if cart?
  end

  def checkout!(purchase)
    transaction do
      raise CheckoutError.new("cart") unless cart?
      raise CheckoutError.new("items") unless any_items?
      raise CheckoutError.new("user") unless user

      create_purchase!(
        ship_name: purchase.ship_name, ship_address: purchase.ship_address,
        ship_due_date: purchase.ship_due_date, ship_due_time: purchase.ship_due_time)
    end

  rescue ActiveRecord::StaleObjectError
    reload
    checkout!(purchase)
  end

  def subtotal
    items.map{ |item| item.quantity * item.price }.sum
  end

  def total_quantity
    items.sum(&:quantity)
  end
end
