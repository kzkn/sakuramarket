
class Carts::ItemsController < ApplicationController
  before_action :set_cart_item, only: [:destroy]

  def destroy
    @cart_item.destroy
    redirect_to cart_path, notice: '商品をカートから削除しました。'
  end

  private
  def set_cart_item
    @cart_item = CartItem.find(params[:id])
  end
end
