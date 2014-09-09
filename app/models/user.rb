class User < ActiveRecord::Base

  #devise................................................................
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,
  # :recoverable, :rememberable, :validatable,
  devise :invitable, :database_authenticatable, :registerable,
         :confirmable, :invitable, :invite_for => 2.weeks

  #Associations..........................................................
  # FIX- Does this work?
  has_many :appointments

  #Query Interface.......................................................
  default_scope { where(active: true) }

  #Validations............................................................
  validates_presence_of :name, :email, :phone_number
  validates :email, format: { with: /\A\w+@\w+\.\w+\Z/,
                              message: 'is Invalid'},
                              uniqueness: true, allow_blank: true
  validates :phone_number, length: { minimum: 9 }, allow_blank: true

end