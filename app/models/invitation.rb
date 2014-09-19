class Invitation < ActiveRecord::Base
  #Callbacks.............................................................
  before_create :generate_invitation_token
  after_create :send_invitation_mail

  #Validations............................................................
  validates_presence_of :name, :email, :phone_number
  validates :email, format: { with: /\A\w+@\w+\.\w+\Z/,
                              message: 'is Invalid' },
                              uniqueness: true, allow_blank: true
  validate :unique_email

  def accept!
    update_column(:invitation_accepted_at, Time.now)
  end

  private
  def generate_invitation_token
    self.invitation_token = SecureRandom.urlsafe_base64(20)
  end

  def send_invitation_mail
    InvitationMailer.invitation_email(self).deliver
  end

  def unique_email
    errors[:base] = 'Email id is already taken' if User.where(email: email).first
  end

end
