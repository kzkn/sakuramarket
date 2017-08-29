class Purchase < ApplicationRecord
  TAX_RATE = 0.08

  belongs_to :order, touch: true

  validates :order, presence: true, uniqueness: true
  validates :tax_rate, numericality: true
  validates :cod_cost, numericality: true
  validates :ship_cost, numericality: true
  validates :total, numericality: true
  validates :ship_name, presence: true
  validates :ship_address, presence: true
  validates :ship_due_date, presence: true, inclusion: { in: proc { Purchase.ship_date_candidates } }
  validates :ship_due_time, presence: true, inclusion: { in: proc { Purchase.ship_time_candidates } }
  validate :order_has_item, :order_is_assigned_to_user, if: :has_order?

  before_validation :set_tax_rate, on: :create
  before_validation :set_attrs_from_order, on: :create, if: :has_order?

  def self.ship_date_candidates
    # 3 営業日から 14 営業日
    today = Date.current
    (1..Float::INFINITY).lazy
      .map{ |i| today + i }
      .select{ |d| !d.saturday? && !d.sunday? }
      .take(14)
      .drop(2)
      .to_a
  end

  def self.ship_time_candidates
    %w(8-12 12-14 14-16 16-18 18-20 20-21)
  end

  def self.new_for_user(user)
    Purchase.new(ship_name: user.ship_name, ship_address: user.ship_address)
  end

  def ship_params
    { ship_name: ship_name, ship_address: ship_address }
  end

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
  def has_order?
    order.present?
  end

  def order_has_item
    errors.add(:order, 'カートが空です。') unless order.items.exists?
  end

  def order_is_assigned_to_user
    errors.add(:order, 'どのユーザーにも割り当てられていないカートです。') unless order.user.present?
  end

  def set_tax_rate
    self.tax_rate = TAX_RATE
  end

  def set_attrs_from_order
    self.cod_cost = Purchase.cod_cost(order)
    self.ship_cost = Purchase.ship_cost(order)
    self.total = Purchase.total(order, tax_rate)
  end

  def self.taxation(n, tax_rate)
    (n + n * tax_rate.to_r).to_i
  end
end
