class BookingConfirmationMailer < ActionMailer::Base
  default from: "vinsol2011@gmail.com"

  def booking_email(appointment)
    @appointment = appointment
    mail(to: @appointment.customer.email, subject: 'AMS - Appointment Confirmation')
  end
end
