class Ordering < ApplicationRecord
  belongs_to :user
  belongs_to :order

  validates :order, uniqueness: true
end
