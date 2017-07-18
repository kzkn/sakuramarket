module ProductsHelper
  def product_image_tag(product, size = "small")
    image_tag(product.image_path, alt: product.name, class: "product_image--#{size}")
  end
end
