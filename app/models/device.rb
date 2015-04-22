class Device < ActiveRecord::Base
	belongs_to :report
	before_create do |doc|
  		doc.api_key = doc.generate_api_key
	end
	
	def generate_api_key
  	token = SecureRandom.base64.tr('+/=', 'Qrt')
      loop do
	    	if Device.exists?(api_key: token) == false
          break
        end
        token = SecureRandom.base64.tr('+/=', 'Qrt')
  		end
      return token
	end

end
