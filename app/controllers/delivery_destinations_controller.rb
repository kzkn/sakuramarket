# -*- coding: utf-8 -*-
class DeliveryDestinationsController < ApplicationController
  before_action :authenticate!

  def edit
    @delivery = current_user.get_or_new_delivery_destination
  end

  def update
    @delivery = current_user.get_or_new_delivery_destination
    if @delivery.update(delivery_destination_params)
      redirect_to delivery_path, notice: "送り先を更新しました。"
    else
      render :edit
    end
  end

  private
  def delivery_destination_params
    params.require(:delivery_destination).permit(:name, :address)
  end
end
