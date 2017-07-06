# -*- coding: utf-8 -*-
class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_item, only: [:update]

  def show
  end

  def update
    @cart.add(@item.product, @item.quantity)
    redirect_to cart_path, notice: '商品をカートに追加しました。'
  end

  private
  def set_cart
    @cart = ensure_cart_created
  end

  def set_cart_item
    form = CartEditForm.new(cart_edit_form_params)
    product = Product.find(form.product_id)
    @item = CartItem.new(product: product, quantity: form.quantity)
  end

  def cart_edit_form_params
    params.require(:cart_edit_form).permit(:product_id, :quantity)
  end
end
