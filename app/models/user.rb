# -*- coding: utf-8 -*-
class User < ApplicationRecord
  has_secure_password
  has_one :cart, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :email, presence: true, uniqueness: true, email: true
end
