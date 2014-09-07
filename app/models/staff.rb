require 'staff_callback'

class Staff < User
  # has_many :appointments, foreign_key: 'staff_id'
  # has_one :staffs_information, class_name: 'User', foreign_key: 'staff_id'
  
  #Callbacks..........................................................
  after_update StaffCallbacks, if: Proc.new { |staff| !staff.active? && staff.active_changed? }

  #Associations......................................................
  has_and_belongs_to_many :services, :join_table => :services_staffs
  accepts_nested_attributes_for :services
  has_many :availabilities

  #Query Interface....................................................
  default_scope { order(:name) }

  #Validations........................................................
  validates_presence_of :services

end
