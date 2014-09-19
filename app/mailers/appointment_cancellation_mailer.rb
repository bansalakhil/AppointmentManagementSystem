class AppointmentCancellationMailer < ActionMailer::Base
  default from: "vinsol2011@gmail.com"

  def cancellation_email(appointment)
    @appointment = appointment
    mail(to: @appointment.customer.email, subject: 'AMS - Appointment Cancellation')
  end
end
