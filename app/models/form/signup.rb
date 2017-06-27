# -*- coding: utf-8 -*-
class Form::Signup
  include ActiveModel::Model

  # TODO uniqueness が効かない、エラーも出ない
  # TODO 面倒だから Form::Login もろとも User に寄せようかな
  attr_accessor :email_address, :password,
    :delivery_destination_name, :delivery_destination_address

  validates :email_address, presence: true
  validates :password, presence: true
  validates :delivery_destination_name, presence: true,
    if: ->(s){ s.delivery_destination_address.present? }
  validates :delivery_destination_address, presence: true,
    if: ->(s){ s.delivery_destination_name.present? }

  def register
    return false unless valid?

    user = save_user
    if user
      save_delivery_destination(user)
    else
      false
    end
  end

  private
  def save_user
    user = User.new(
      email_address: self.email_address,
      password: self.password)
    user.save && user
  end

  def save_delivery_destination(user)
    # TODO user にくっつけようかな, くっつけないならトランザクション
    if self.delivery_destination_name.present?
      dd = DeliveryDestination.new(
        user: user,
        name: self.delivery_destination_name,
        address: self.delivery_destination_address)
      dd.save
    else
      return true
    end
  end
end
