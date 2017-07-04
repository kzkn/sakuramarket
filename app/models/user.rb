class User < ApplicationRecord
  has_one :delivery_destination
  has_one :cart
  has_secure_password

  validates :email_address, presence: true, uniqueness: true

  def get_or_new_delivery_destination
    self.delivery_destination || build_delivery_destination
  end

  def set_cart(cart)
    self.cart = cart
    self.save!
  end
end
