# TODO payment を作り、現在でいう order を payment へ移動させる。order が済んでいるかどうかは、payment の存在有無で確認する
# TODO バリデーションの関係から送付先情報を別テーブルに持って行きたい
class Order < ApplicationRecord
  has_one :ordering, dependent: :destroy
  has_one :user, through: :ordering
  has_many :items, class_name: 'OrderItem'

  SHIP_PERIOD_CANDIDATES = %w(8-12 12-14 14-16 16-18 18-20 20-21).freeze.map(&:freeze)

  # TODO 仮実装
  scope :not_paid, -> { where(ship_date: nil) }

  # TODO どっかに持って行きたい
  # validates :ship_to_name, presence: true
  # validates :ship_to_address, presence: true
  # validates :ship_date, order_ship_date: true
  # validates :ship_period, inclusion: { in: Order::SHIP_PERIOD_CANDIDATES }

  # before_save :set_cod_fee
  # before_save :set_ship_fee

  # def self.pre(cart)
  #   cart.user.orders.build.tap do |order|
  #     order.add_cart_items(cart)
  #   end
  # end

  def make(form)
    # TODO payment とか shipping に移動させたい。バリデーションの関係から。
    # TODO メソッド名がふさわしくない
    transaction do
      order.update!(
        ship_to_name: form.ship_to_name,
        ship_to_address: form.ship_to_address,
        ship_date: form.ship_date,
        ship_period: form.ship_period,
        ship_fee: CashOnDelivery.fee(subtotal),
        cod_fee: Ship.fee(total_quantity)
      )
    end

    self
  end

  def self.ship_date_candidates
    # 3 営業日から 14 営業日先の日付の配列を作る
    today = Date.current
    (3..Float::INFINITY).lazy
      .map{ |i| today + i }
      .select{ |d| d.business_day? }
      .take(14)
      .to_a
  end

  def owner?(user)
    self.user == user
  end

  def add(product, quantity)
    return if quantity <= 0

    transaction do
      item = items.joins(:product_ordering).find_or_initialize_by(product_ordering: { product: product })  # FIXME 失敗する。product の UD がないなら order_item -> product に直接リンクを晴れるので楽ちんになるが。
      if item.new_record?
        item.quantity = quantity
        item.save!
      else
        item.increment!(:quantity, quantity.to_i)  # TODO to_i 消したい
        self.touch
      end
    end
  end

  def move_items_to(other)
    transaction do
      items.each { |item| other.add(item.product, item.quantity) }
      destroy!
    end

    other
  end

  def add_cart_items(cart)
    cart.items.each do |item|
      self.items << item.order
    end
  end

  def has_items?
    items.any?{ |item| item.quantity > 0 }
  end

  def subtotal
    items.map(&:subtotal).sum
  end

  def total_quantity
    items.map(&:quantity).sum
  end

  def cod_fee
    @cod_fee ||= CashOnDelivery.fee(subtotal)
  end

  def ship_fee
    @ship_fee ||= Ship.fee(total_quantity)
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
