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
    @purchase = Purchase.new_for_user(current_user)
  end

  def create
    @purchase = @cart.build_purchase(purchase_form_params)
    if @purchase.valid? && current_user.update(@purchase.ship_params) && @purchase.save
      unset_current_cart
      redirect_to root_path, notice: '注文を受け付けました。ありがとうございました。'
    else
      render :new
    end
  end

  private
  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def set_cart
    @cart = set_current_cart_surely
  end

  def require_cart_is_not_empty
    unless @cart.items.exists?
      redirect_to root_path, alert: 'カートに商品がありません。'
    end
  end

  def purchase_form_params
    params.require(:purchase).permit(:ship_name, :ship_address, :ship_due_date, :ship_due_time)
  end
end
