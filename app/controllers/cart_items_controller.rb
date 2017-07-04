# -*- coding: utf-8 -*-
class CartItemsController < ApplicationController
  before_action :set_cart, :set_product, only: [:create]

  def create
    @cart.add_item!(@product, cart_item_params[:quantity].to_i)
    redirect_to cart_path, notice: "カートに追加しました。"
  end

  private
  def set_cart
    @cart = current_cart_ensured
  end

  def set_product
    @product = Product.find(cart_item_params[:product_id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
