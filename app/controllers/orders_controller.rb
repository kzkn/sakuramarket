class OrdersController < ApplicationController
  before_action :authenticate!
  before_action :set_cart, only: %i(new create)
  before_action :require_cart_is_not_empty, only: %i(new create)

  def new
    @form = PurchaseForm.new_for_user(current_user)
  end

  def create
    @form = PurchaseForm.new(purchase_form_params)
    if @form.valid?
      @cart.checkout!(@form)
      @form.update_shipping(current_user)
      redirect_to root_path, notice: '注文を受け付けました。ありがとうございました。'
    else
      render :new
    end
  end

  private
  def set_cart
    @cart = ensure_cart_created
  end

  def require_cart_is_not_empty
    unless @cart.any_items?
      redirect_to root_path, notice: 'カートに商品がありません。'
    end
  end

  def purchase_form_params
    params.require(:purchase_form).permit(:ship_name, :ship_address, :ship_due_date, :ship_due_time)
  end
end
