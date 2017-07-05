# -*- coding: utf-8 -*-
class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, class_name: "CartItem", dependent: :destroy

  def add_item!(product, quantity)
    # TODO 楽観的ロックの競合で失敗したらもう一回
    item = items.find_or_initialize_by(product: product)
    if item.new_record?
      item.quantity = quantity
      item.save!
    else
      item.increment!(:quantity, quantity.to_i)
      self.touch
    end
  end

  def price_subtotal
    items.map{|item| item.quantity * item.price }.sum
  end
end
