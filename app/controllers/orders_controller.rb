class OrdersController < ApplicationController
  before_action :authenticate!
  before_action :set_cart
  before_action :require_cart_is_not_empty

  def new
    @form = OrderForm.new_for_user(current_user)
    @order = Order.pre(@cart)
  end

  def create
    @form = OrderForm.new(order_form_params)
    if @form.valid?
      Order.make(@form, @cart)
      @form.update_shipping(current_user)
      redirect_to root_path, notice: '注文を受け付けました。ありがとうございました。'
    else
      @order = Order.pre(@cart)
      render :new
    end
  end

  private
  def set_cart
    @cart = ensure_cart_created
  end

  def require_cart_is_not_empty
    unless @cart.has_items?
      redirect_to root_path, notice: 'カートに商品がありません。'
    end
  end

  def order_form_params
    params.require(:order_form).permit(:ship_to_name, :ship_to_address, :reuse, :ship_date, :ship_period)
  end
end
