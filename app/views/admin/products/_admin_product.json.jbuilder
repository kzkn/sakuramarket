json.extract! admin_product, :id, :name, :image_filename, :price, :description, :hidden, :created_at, :updated_at
json.url admin_product_url(admin_product, format: :json)
