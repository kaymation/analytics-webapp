class Device < ActiveRecord::Base
	belongs_to :report
	before_create do |doc|
  		doc.api_key = doc.generate_api_key
	end
	
	def generate_api_key
  		loop do
	    	token = SecureRandom.base64.tr('+/=', 'Qrt')
	    	break token unless Device.exists?(api_key: token)
  		end
	end

end
