class CartEditForm
  include ActiveModel::Model

  attr_reader :product
  attr_accessor :product_id, :quantity

  def product=(product)
    self.product_id = product.id
  end
end
