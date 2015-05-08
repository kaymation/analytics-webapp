100.times do
	Report.seed do |r|
		r.item = ["Small Burger", "Medium Burger", "Large Burger"].sample
		r.when = rand(2.years).seconds.ago
		r.preptime = rand(1000)
		r.device_id = 2
		r.restaurant_id = 6
		r.user_id = User.where(email: 'demo@example.com').first.id
		r.order_number = rand(100)
	end
end