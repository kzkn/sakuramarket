class User < ApplicationRecord
  has_one :cart, dependent: :destroy
  has_secure_password

  validates :email_address, presence: true, uniqueness: true
end
