ActionMailer::Base.smtp_settings = {
:address => "smtp.mandrillapp.com",
:port => 587,
:domain => "mandrillapp.com",
:user_name => "app31777222@heroku.com",
:password => "5OunalrBFKaYWKZG1ZFAwg",
:authentication => "login",
:enable_starttls_auto => true
}