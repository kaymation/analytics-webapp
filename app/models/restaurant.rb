class Restaurant < ActiveRecord::Base
	belongs_to :user
	belongs_to :reports
  has_many :items
  has_many :devices
end
