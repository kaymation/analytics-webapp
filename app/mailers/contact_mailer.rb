class ContactMailer < ActionMailer::Base
  default :from => 'app31777222@heroku.com'
	def report_mail(name, email, message)
		@name = name
		@email = email
		@message = message
		logger.debug("ActionMailer Invoked")
		mail(:to => 'customercare@selectelectronics.com', :subject => "Inquiry from #{name}<#{email}>")
	end
end
