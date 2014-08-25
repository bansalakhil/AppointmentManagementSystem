class User < ActiveRecord::Base
  
  # has_one :speciality, ->{ where type:'Doctor' }, through: :doctors_information
  # has_many :appointments
  validates :name, :address, :email, presence: true
  validates :email, format: { with: /\A\w+@\w+\.\w+\Z/,
                              message: 'is Invalid'},
                              uniqueness: true
  validates :phone_number, numericality: { greater_than: 100000000 }
end