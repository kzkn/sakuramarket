class Admin::Products::PositionsController < ApplicationController
  before_action :set_product

  def update
    @product.update!(product_params)
    head 200
  end

  private
  def set_product
    @product = Product.find(params[:product_id])
  end

  def product_params
    params.require(:product).permit(:position)
  end
end
