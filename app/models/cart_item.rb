class CartItem < ApplicationRecord
  belongs_to :cart, touch: true
  belongs_to :product
end
