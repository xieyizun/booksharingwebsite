class UserMailer < ActionMailer::Base
  default from: "foobar@example.org"

  def welcome_email(user)
  	@user = user
  	@url = 'http://example.com/login'
  	mail(to: @user.email, subject: 'Welcome to Book Lending Site')
  end
end

