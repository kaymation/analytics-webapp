Report.destroy_all

100.times do
	Report.seed do |r|
		r.item = ["Small Burger", "Medium Burger", "Large Burger"].sample
		r.when = rand(2.years).seconds.ago
		r.preptime = rand(1000)
		r.device_id = 1
		r.restaurant_id = Restaurant.maximum(:id)
		r.user_id = 2
		r.order_number = rand(100)
	end
end