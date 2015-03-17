Report.destroy_all
100.times do
	Report.seed do |r|
		r.item = ["Small Burger", "Medium Burger", "Large Burger"].sample
		r.when = rand(2.years).seconds.ago
		r.preptime = rand(1000)
		r.device_id = 1
		r.restaurant_id = Restaurant.all.sort_by(:created_at).first
		r.user_id = User.where(email: 'mvpetronaci@gmail.com').first.id
		r.order_number = rand(100)
	end
end