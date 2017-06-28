# -*- coding: utf-8 -*-
class Form::Signup
  include ActiveModel::Model

  attr_accessor :email_address, :password, :password_confirmation

  # TODO validation
  validates :email_address, presence: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  def register
    return false unless valid?
    save_user
  end

  private
  def save_user
    user = User.new(email_address: email_address, password: password,
      password_confirmation: password_confirmation)
    user.save && user
  end
end
