class User < ActiveRecord::Base
  acts_as_paranoid

  #devise................................................................
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  # :recoverable, :rememberable, :validatable,
  devise :database_authenticatable, :registerable,
         :confirmable, :recoverable

  #Associations..........................................................

  #Callbacks.............................................................
  before_create :set_user_type
  after_create :delete_invitation

  #Query Interface.......................................................

  #Validations............................................................
  validates_presence_of :name, :email, :phone_number
  validates :email, format: { with: /\A\w+@\w+\.\w+\Z/,
                              message: 'is Invalid'},
                              uniqueness: true, allow_blank: true

  protected
  
  def confirmation_required?
    false
  end

  def set_user_type
    self.type = Invitation.where(email: email).first.invitee_type if Invitation.where(email: email).first
  end

  def delete_invitation
    Invitation.where(email: email).first.destroy if Invitation.where(email: email).first
  end

end