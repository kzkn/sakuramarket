class CartEditForm
  include ActiveModel::Model

  attr_accessor :product_id, :quantity

  validates :product_id, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def product=(product)
    self.product_id = product.id
  end
end
