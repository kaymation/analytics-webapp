class Restaurant < ActiveRecord::Base
	belongs_to :user
	belongs_to :reports
end
