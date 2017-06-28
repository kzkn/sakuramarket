class User < ApplicationRecord
  has_one :delivery_destination

  attr_accessor :password

  validates :email_address, presence: true, uniqueness: true

  before_save :set_salt, :set_hashed_password

  def self.authenticate(email_address, password_plain)
    user = User.find_by(email_address: email_address)
    user if user && user.valid_password?(password_plain)
  end

  def valid_password?(password_plain)
    self.hashed_password == hash_password(password_plain)
  end

  def hash_password(password_plain)
    Digest::SHA1.hexdigest("#{salt}#{password_plain}")
  end

  def set_salt
    self.salt ||= User.generate_salt
  end

  def set_hashed_password
    self.hashed_password = hash_password(self.password) if self.password
  end

  def self.generate_salt
    SecureRandom.hex(16)
  end

  def get_or_new_delivery_destination
    self.delivery_destination || build_delivery_destination
  end
end
