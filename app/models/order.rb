class Order < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'OrderItem'

  before_save :set_cod_fee
  before_save :set_ship_fee

  def self.pre(cart)
    Order.new(user: cart.user).tap do |o|
      o.add_cart_items(cart)
    end
  end

  def self.make(form, cart)
    order = Order.new(user: cart.user,
      ship_to_name: form.ship_to_name, ship_to_address: form.ship_to_address,
      ship_date: form.ship_date, ship_period: form.ship_period).tap do |o|
      o.add_cart_items(cart)
    end

    order.transaction do
      order.save!
      cart.destroy!
    end

    order
  end

  def self.ship_period_candidates
    %w(8-12 12-14 14-16 16-18 18-20 20-21)
  end

  def self.ship_date_candidates
    # 3 営業日から 14 営業日先の日付の配列を作る
    today = Date.today
    (3..Float::INFINITY).lazy
      .map{ |i| today + i }
      .select{ |d| d.business_day? }
      .take(14)
      .map{ |d| d.iso8601 }
      .to_a
  end

  def add_cart_items(cart)
    cart.items.each do |item|
      self.items << item.order
    end
  end

  def subtotal
    items.map(&:subtotal).sum
  end

  def total_quantity
    items.map(&:quantity).sum
  end

  def cod_fee
    @cod_fee || CashOnDelivery.fee(subtotal)
  end

  def ship_fee
    @ship_fee || Ship.fee(total_quantity)
  end

  def total_without_tax
    subtotal + cod_fee + ship_fee
  end

  def tax
    tax_of(total_without_tax)
  end

  def total
    n = total_without_tax
    n + tax_of(n)
  end

  private
  def tax_of(n)
    (n * tax_rate).to_i
  end

  def set_cod_fee
    self.cod_fee = CashOnDelivery.fee(subtotal)
  end

  def set_ship_fee
    self.ship_fee = Ship.fee(total_quantity)
  end
end

module CashOnDelivery
  def self.fee(amount)
    return 300 if amount < 10000
    return 400 if amount < 30000
    return 600 if amount < 100000
    return 1000
  end
end

module Ship
  def self.fee(quantity)
    # 1..5   -> 600
    # 6..10  -> 1200
    # ...
    600 * (((quantity - 1) / 5) + 1)
  end
end

class Date
  def business_day?
    !saturday? && !sunday?
  end
end
