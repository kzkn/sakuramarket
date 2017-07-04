class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :image]

  def show
    @cart_item = CartItem.new(product: @product, quantity: 1)
  end

  def image
    send_data(@product.image)
  end

  private
  def set_product
    @product = Product.visible.find(params[:id])
  end
end
