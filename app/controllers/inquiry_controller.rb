class InquiryController < ApplicationController
	def index
	end

	def send_mail
		ContactMailer.report_mail(params['name'], params['email'], params['message']).deliver
    	flash[:notice] = "Message sent successfully"
    	render 'home/index.html.erb'
	end
end
