class User < ApplicationRecord
  has_secure_password

  has_many :orderings
  has_many :orders, through: :orderings
  has_many :purchases, through: :orders

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def cart
    @cart ||= orders.only_cart.first
  end

  def cart=(cart)
    @cart = cart
    orderings.create!(order: cart) if cart
  end
end
