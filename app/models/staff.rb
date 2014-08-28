class Staff < User
  # has_many :appointments, foreign_key: 'staff_id'
  # has_one :staffs_information, class_name: 'User', foreign_key: 'staff_id'

  #Assoiciations...................................................
  has_and_belongs_to_many :services, :join_table => :services_staffs, dependent: :destroy
  accepts_nested_attributes_for :services
  has_many :availabilities

end