# -*- coding: utf-8 -*-
class CartsController < ApplicationController
  before_action :set_or_create_cart, only: [:show]

  def show
  end

  private
  def set_or_create_cart
    @cart = current_cart || Cart.create
    set_cart(@cart)
  end
end
