class ContactMailer < ActionMailer::Base
  default :from => 'kevinmquigley.41@gmail.com'
	def report_mail(name, email, message)
		@name = name
		@email = email
		@message = message
		mail(:to => 'kevinmquigley.41@gmail.com', :subject => "Inquiry from #{name}<#{email}>")
	end
end
