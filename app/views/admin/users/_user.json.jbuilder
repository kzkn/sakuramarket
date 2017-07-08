json.extract! user, :id, :email, :ship_to_name, :ship_to_address, :created_at, :updated_at
json.url user_url(user, format: :json)
