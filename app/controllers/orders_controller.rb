class OrdersController < ApplicationController
  before_action :authenticate!
  before_action :set_order, only: %i(show)
  before_action :set_cart, only: %i(new create)
  before_action :require_cart_is_not_empty, only: %i(new create)

  def index
    @orders = current_user.orders.only_checked.includes(:purchase).order("purchases.created_at desc")
  end

  def show
  end

  def new
    @form = PurchaseForm.new_for_user(current_user)
  end

  def create
    @form = PurchaseForm.new(purchase_form_params)
    if @form.valid?
      @cart.checkout!(@form)
      current_user.update!(@form.ship_params)
      unset_current_cart
      redirect_to root_path, notice: '注文を受け付けました。ありがとうございました。'
    else
      render :new
    end

  rescue Order::CheckoutError
    redirect_to root_path, alert: '注文を受け付けられませんでした。'
  end

  private
  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_cart
    @cart = ensure_cart_created
  end

  def require_cart_is_not_empty
    unless @cart.any_items?
      redirect_to root_path, alert: 'カートに商品がありません。'
    end
  end

  def purchase_form_params
    params.require(:purchase_form).permit(:ship_name, :ship_address, :ship_due_date, :ship_due_time)
  end
end
