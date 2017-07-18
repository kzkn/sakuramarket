json.extract! admin_user, :id, :email, :ship_name, :ship_address, :created_at, :updated_at
json.url admin_user_url(admin_user, format: :json)
