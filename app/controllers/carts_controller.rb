# -*- coding: utf-8 -*-
class CartsController < ApplicationController
  before_action :set_or_create_cart, :associate_cart_to_user, only: [:show]

  def show
  end

  private
  def set_or_create_cart
    @cart = current_cart || Cart.create
    set_cart(@cart)
  end

  def associate_cart_to_user
    current_user && current_user.set_cart(@cart)
  end
end
