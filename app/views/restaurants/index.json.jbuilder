json.array!(@restaurants) do |restaurant|
  json.extract! restaurant, :id, :name, :user_id
  json.url restaurant_url(restaurant, format: :json)
end
