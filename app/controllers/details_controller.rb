class DetailsController < ApplicationController
  before_action :set_product, only: [:show]

  def show
    @form = CartEditForm.new(product: @product, quantity: 1)
  end

  private
  def set_product
    @product = Product.visible.find(params[:id])
  end
end
