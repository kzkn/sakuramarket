class PurchaseForm
  include ActiveModel::Model

  attr_accessor :ship_name, :ship_address, :ship_due_date, :ship_due_time
  validates :ship_name, presence: true
  validates :ship_address, presence: true
  validates :ship_due_date, presence: true
  validates :ship_due_time, presence: true

  def self.ship_date_candidates
    # 3 営業日から 14 営業日
    today = Date.current
    (3..Float::INFINITY).lazy
      .map{ |i| today + i }
      .select{ |d| d.business_day? }
      .take(12)
      .map(&:iso8601)
      .to_a
  end

  def self.ship_time_candidates
    %w(8-12 12-14 14-16 16-18 18-20 20-21)
  end

  def self.new_for_user(user)
    PurchaseForm.new(ship_name: user.ship_name, ship_address: user.ship_address)
  end

  def ship_params
    { ship_name: ship_name, ship_address: ship_address }
  end
end

class Date
  def business_day?
    !saturday? && !sunday?
  end
end
