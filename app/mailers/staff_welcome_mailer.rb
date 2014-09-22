class StaffWelcomeMailer < ActionMailer::Base
  default from: "vinsol2011@gmail.com"

  def welcome_email(staff)
    @staff = staff
    mail(to: @staff.email, subject: 'Welcome to AMS')
  end
end
