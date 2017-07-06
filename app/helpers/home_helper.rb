module HomeHelper
  def product_display(product)
    return nil unless product

    content_tag(:div, class: "col-xs-4") do
      content_tag(:a, href: product_path(product), class: "thumbnail product") do
        img = image_tag(product_image_path(product), alt: product.name, class: "product__image")
        name = content_tag(:span, product.name)
        img + name
      end
    end
  end
end
