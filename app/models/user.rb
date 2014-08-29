class User < ActiveRecord::Base

  #devise................................................................
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  # :recoverable, :rememberable, :validatable,
  devise :database_authenticatable, :registerable,
         :confirmable
         
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
end