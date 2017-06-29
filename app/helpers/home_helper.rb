module HomeHelper
  def product_display(product)
    return nil unless product

    content_tag(:div, class: "col-xs-4") do
      content_tag(:div, class: "product") do
        img = content_tag(:div, class: "product__image") do
          link_to(
            image_tag(image_product_path(product), alt: product.name, size: "200x200"),
            product)
        end
        link = content_tag(:div, class: "product__name") do
          link_to(product.name, product)
        end
        img + link
      end
    end
  end
end
