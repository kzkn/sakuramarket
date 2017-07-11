# -*- coding: utf-8 -*-
class OrderForm
  include ActiveModel::Model

  CHECKED = '1'

  attr_accessor :ship_to_name, :ship_to_address, :ship_date, :ship_period, :reuse
  validates :ship_to_name, presence: true
  validates :ship_to_address, presence: true
  validates :ship_date, inclusion: { in: Order.ship_date_candidates.map(&:iso8601) }
  validates :ship_period, inclusion: { in: Order.ship_period_candidates }

  def self.new_for_user(user)
    OrderForm.new(ship_to_name: user.ship_to_name, ship_to_address: user.ship_to_address)
  end

  def update_shipping(user)
    if reuse?
      user.update(ship_to_name: ship_to_name, ship_to_address: ship_to_address)
    end
  end

  def reuse?
    reuse == CHECKED
  end
end
