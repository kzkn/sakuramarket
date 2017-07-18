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
    self.cod_cost = order.compute_cod_cost unless cod_cost
  end

  def ensure_has_ship_cost
    self.ship_cost = order.compute_ship_cost unless ship_cost
  end

  def ensure_has_total
    self.total = taxation(order.compute_subtotal + cod_cost + ship_cost)
  end

  def ensure_has_ship_name
    self.ship_name = order.user.ship_name unless ship_name
  end

  def ensure_has_ship_address
    self.ship_address = order.user.ship_address unless ship_address
  end

  def taxation(n)
    n + (n * tax_rate).to_i
  end
end

class Date
  def business_day?
    !saturday? && !sunday?
  end
end
