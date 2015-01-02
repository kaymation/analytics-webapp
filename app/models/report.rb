class Report < ActiveRecord::Base
	has_one :restaurant
	has_one :user
end
