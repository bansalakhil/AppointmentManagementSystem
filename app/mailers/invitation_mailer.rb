class InvitationMailer < ActionMailer::Base
  default from: "vinsol2011@gmail.com"

  def invitation_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: 'You are invited to our site')
  end
end