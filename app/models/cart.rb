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

  def price_subtotal
    items.map{|item| item.quantity * item.price }.sum
  end
end
