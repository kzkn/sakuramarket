# -*- coding: utf-8 -*-
module ProductsHelper
  def product_image_tag(product, size)
    # TODO もう少し使いやすくする
    image_tag product_image_path(product), alt: product.name, size: "#{size}x#{size}"
  end
end
