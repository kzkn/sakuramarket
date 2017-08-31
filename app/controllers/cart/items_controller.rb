class Cart::ItemsController < ApplicationController
  before_action :set_item

  def destroy
    @item.destroy
    redirect_to cart_path, notice: 'カートから商品を削除しました。'
  end

  private
  def set_item
    cart = set_current_cart_surely
    @item = cart.items.find(params[:id])
  end
end
