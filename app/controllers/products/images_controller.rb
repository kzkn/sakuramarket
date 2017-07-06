class Products::ImagesController < ApplicationController
  before_action :set_product, only: [:show]

  def show
    send_data(@product.image)
  end

  private
  def set_product
    @product = Product.visible.find(params[:product_id])
  end
end
