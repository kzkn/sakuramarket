class Orders::HistoriesController < ApplicationController
  before_action :authenticate!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders
  end

  def show
  end

  private
  def set_order
    @order = current_user.orders.find(params[:id])
  end
end
