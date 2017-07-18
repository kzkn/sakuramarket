class LineItem < ApplicationRecord
  belongs_to :order, touch: true
  belongs_to :product

  validates :product, uniqueness: { scope: :order }
  validates :price, numericality: { only_integer: true }
  validates :quantity, numericality: { only_integer: true }

  before_validation :ensure_has_price

  private
  def ensure_has_price
    self.price = product.price unless price
  end
end
