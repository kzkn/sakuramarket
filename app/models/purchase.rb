class Purchase < ApplicationRecord
  TAX_RATE = 0.08

  belongs_to :order, touch: true

  validates :tax_rate, numericality: true
  validates :cod_cost, numericality: true
  validates :ship_cost, numericality: true
  validates :total, numericality: true
  validates :ship_name, presence: true
  validates :ship_address, presence: true
  validates :ship_due_date, presence: true
  validates :ship_due_time, presence: true

  before_validation :ensure_has_values

  def self.cod_cost(order)
    Cost.of_cod(order.subtotal)
  end

  def self.ship_cost(order)
    Cost.of_ship(order.total_quantity)
  end

  def self.total(order, tax_rate = TAX_RATE)
    total = order.subtotal + Purchase.cod_cost(order) + Purchase.ship_cost(order)
    Purchase.taxation(total, tax_rate)
  end

  private
  def ensure_has_values
    ensure_has_tax_rate
    ensure_has_cod_cost
    ensure_has_ship_cost
    ensure_has_total
    ensure_has_ship_name
    ensure_has_ship_address
  end

  def ensure_has_tax_rate
    self.tax_rate = TAX_RATE unless tax_rate
  end

  def ensure_has_cod_cost
    self.cod_cost = Purchase.cod_cost(order) unless cod_cost
  end

  def ensure_has_ship_cost
    self.ship_cost = Purchase.ship_cost(order) unless ship_cost
  end

  def ensure_has_total
    self.total = Purchase.total(order, tax_rate) unless total
  end

  def ensure_has_ship_name
    self.ship_name = order.user.ship_name unless ship_name
  end

  def ensure_has_ship_address
    self.ship_address = order.user.ship_address unless ship_address
  end

  def self.taxation(n, tax_rate)
    n + (n * tax_rate).to_i
  end
end
