class User < ApplicationRecord
  has_secure_password

  has_many :user_orders
  has_many :orders, through: :user_orders
  has_many :purchases, through: :orders

  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  def cart
    @cart ||= orders.only_cart.first
  end

  def cart=(cart)
    @cart = cart
    user_orders.create!(order: cart) if cart.present?
  end

  def admin?
    admin
  end
end
