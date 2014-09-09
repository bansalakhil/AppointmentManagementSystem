require 'staff_callback'

class Staff < User
  # FIX- Why did you remove this?
  # has_many :appointments, foreign_key: 'staff_id'
  
  #Callbacks..........................................................
  after_update StaffCallbacks, if: Proc.new { |staff| !staff.active? && staff.active_changed? }

  #Associations......................................................
  # FIX- Remove join_table
  has_and_belongs_to_many :services, :join_table => :services_staffs
  
  # FIX- Do we have nested form for creating/updating services inside staff form anywhere in the app?
  accepts_nested_attributes_for :services
  has_many :availabilities

  #Query Interface....................................................
  default_scope { order(:name) }

  #Validations........................................................
  validates_presence_of :services

end
