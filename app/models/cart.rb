# -*- coding: utf-8 -*-
class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, class_name: "CartItem", dependent: :destroy

  def add_item!(product, quantity)
    # TODO 楽観的ロックの競合で失敗したらもう一回
    cart_item = items.where(product_id: product.id).first
    if cart_item
      cart_item.increment!(:quantity, quantity)
      self.touch
    else
      items.create!(product: product, quantity: quantity, price: product.price)
    end
  end

  def price_subtotal
    items.map{|item| item.quantity * item.price }.sum
  end
end
