# -*- coding: utf-8 -*-
class Form::Signup
  include ActiveModel::Model

  attr_accessor :email_address, :password

  validates :email_address, presence: true
  validates :password, presence: true

  def register
    return false unless valid?
    save_user
  end

  private
  def save_user
    user = User.new(email_address: self.email_address, password: self.password)
    user.save && user
  end
end
