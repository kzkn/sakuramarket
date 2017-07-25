class LineItem < ApplicationRecord
  belongs_to :order, touch: true
  belongs_to :product

  validates :order, presence: true
  validates :product, presence: true
  validates :price, numericality: { only_integer: true }
  validates :quantity, numericality: { only_integer: true }
end
