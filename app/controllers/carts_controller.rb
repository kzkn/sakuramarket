# -*- coding: utf-8 -*-
class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_cart_edit_form, :set_product, only: [:update]

  def show
  end

  def update
    if @form.valid?
      @cart.add(@product, @form.quantity.to_i)
      redirect_to cart_path, notice: '商品をカートに追加しました。'
    else
      render :show
    end
  end

  private
  def set_cart
    @cart = ensure_cart_created
  end

  def set_cart_edit_form
    @form = CartEditForm.new(cart_edit_form_params)
  end

  def set_product
    @product = Product.visible.without_image.find(@form.product_id)
  end

  def cart_edit_form_params
    params.require(:cart_edit_form).permit(:product_id, :quantity)
  end
end
