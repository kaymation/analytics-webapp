json.array!(@reports) do |report|
  json.extract! report, :id, :device, :date, :value, :restaurant_id, :user_id
  json.url report_url(report, format: :json)
end
