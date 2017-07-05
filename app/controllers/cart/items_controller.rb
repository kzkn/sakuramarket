# -*- coding: utf-8 -*-
class Cart::ItemsController < ApplicationController
  before_action :set_cart, :set_product, only: [:create]
  before_action :set_cart_item, only: [:destroy]

  def create
    @cart.add_item!(@product, cart_item_params[:quantity])
    redirect_to cart_path, notice: '商品をカートに追加しました。'
  end

  def destroy
    @cart_item.destroy!
    redirect_to cart_path, notice: '商品をカートから削除しました。'
  end

  private
  def set_cart
    @cart = current_cart_ensured
  end

  def set_product
    @product = Product.find(cart_item_params[:product_id])
  end

  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
