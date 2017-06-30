class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :image]

  def show
  end

  def image
    send_data(@product.image)
  end

  private
  def set_product
    @product = Product.visible.find(params[:id])
  end
end
