class User < ApplicationRecord
  has_secure_password
  has_many :orderings, dependent: :destroy
  has_many :orders, through: :orderings

  validates :email, presence: true, uniqueness: true, email: true

  def cart
    orders.not_paid.first
  end
end
