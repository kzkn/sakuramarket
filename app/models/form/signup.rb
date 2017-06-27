# -*- coding: utf-8 -*-
class Form::Signup
  include ActiveModel::Model

  # TODO uniqueness が効かない、エラーも出ない
  attr_accessor :email_address, :password

  validates :email_address, presence: true
  validates :password, presence: true

  def register
    return false unless valid?

    user = User.new(
      email_address: self.email_address,
      password: self.password)
    user.save
  end
end
