# -*- coding: utf-8 -*-
class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :items, class_name: "CartItem", dependent: :destroy

  def owner?(user)
    self.user == user
  end

  def add(product, quantity)
    return if quantity <= 0

    item = items.find_or_initialize_by(product: product)
    if item.new_record?
      item.quantity = quantity
      item.save!
    else
      item.increment!(:quantity, quantity.to_i)
      self.touch
    end
  end

  def merge(other)
    if other
      transaction do
        other.items.each { |item| self.add(item.product, item.quantity) }
      end
    end

    self
  end

  def subtotal
    items.map(&:subtotal).sum
  end

  def total_quantity
    items.map(&:quantity).sum
  end

  def has_items?
    total_quantity > 0
  end

  private
  def add_items_to_order(order)
    items.each do |item|
      order.items << item.order
    end
  end
end
