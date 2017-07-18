class Carts::ItemsController < ApplicationController
  before_action :set_item, only: [:destroy]

  def destroy
    @item.destroy
    redirect_to cart_path, notice: '商品をカートから削除しました。'
  end

  private
  def set_item
    @item = OrderItem.find(params[:id])
  end
end
