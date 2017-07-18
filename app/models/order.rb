class Order < ApplicationRecord
  class CheckoutError < StandardError; end

  has_many :items, class_name: "LineItem"
  has_one :ordering
  has_one :user, through: :ordering
  has_one :purchase

  scope :without_cart, -> { joins(:purchase) }
  scope :only_cart, -> { left_outer_joins(:purchase).where(purchases: { id: nil }) }

  def cart?
    purchase.nil?
  end

  def any_items?
    items.any?
  end

  def add_item(product, quantity)
    quantity = quantity.to_i
    return unless quantity > 0

    transaction do
      item = items.find_by(product_id: product.id)
      if item
        item.quantity += quantity
        item.save
      else
        items.create(product: product, quantity: quantity)
      end
    end
    # TODO rescue StaleObjectError
  end

  def checkout!(ship)
    transaction do
      raise CheckoutError.new("cart") unless cart?
      raise CheckoutError.new("items") unless any_items?
      raise CheckoutError.new("user") unless user

      create_purchase!(ship_due_date: ship.due_date, ship_due_time: ship.due_time)
    end
    # TODO rescue StaleObjectError
  end

  def compute_subtotal
    items.pluck("sum(quantity * price)")
  end

  def compute_total_quantity
    items.sum(&:quantity)
  end

  def compute_cod_cost
    Cost::of_cod(compute_subtotal)
  end

  def compute_ship_cost
    Cost::of_ship(compute_total_quantity)
  end
end
