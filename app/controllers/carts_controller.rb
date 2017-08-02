class CartsController < ApplicationController
  before_action :set_cart
  before_action :set_product, only: %i(update)

  def show
  end

  def update
    @form = CartEditForm.new(cart_edit_form_params)
    if @form.valid? && @cart.add_item(@product, @form.quantity)
      redirect_to cart_path, notice: '商品をカートに追加しました。'
    else
      redirect_to cart_path, alert: '商品をカートに追加できませんでした。数量、商品を確認してください。'
    end
  end

  private
  def set_cart
    @cart = ensure_cart_created
  end

  def cart_edit_form_params
    params.require(:cart_edit_form).permit(:product_id, :quantity)
  end

  def set_product
    id = cart_edit_form_params[:product_id]
    @product = Product.visible.find(id)
  end
end
