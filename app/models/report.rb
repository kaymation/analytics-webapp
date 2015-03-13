class Report < ActiveRecord::Base
	has_one :restaurant
	has_one :user
	has_one :device
end
