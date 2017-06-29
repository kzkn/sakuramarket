module ProductsHelper
  def product_image_tag(product, size)
    image_tag image_product_path(product), alt: product.name, size: "#{size}x#{size}"
  end
end
