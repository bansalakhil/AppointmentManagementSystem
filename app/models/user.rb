class User < ActiveRecord::Base

  #devise................................................................
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  # :recoverable, :rememberable, :validatable,
  devise :invitable, :database_authenticatable, :registerable,
         :confirmable, :invitable, :invite_for => 2.weeks

  #Query Interface.......................................................
  # attr_accessible :email, :password, :password_confirmation
  # has_one :speciality, ->{ where type:'Doctor' }, through: :doctors_information
  # has_many :appointments
  default_scope { where(active: true) }

  #Validations............................................................
  validates :name, :email, presence: true
  validates :email, format: { with: /\A\w+@\w+\.\w+\Z/,
                              message: 'is Invalid'},
                              uniqueness: true
  validates :phone_number, length: { minimum: 9 }

  #Callbacks..............................................................
  # after_invitation_accepted :redirect_to_path()

end