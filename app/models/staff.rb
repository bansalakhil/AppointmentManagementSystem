class Staff < User
  
  #Associations......................................................
  has_many :appointments, foreign_key: 'staff_id'
  has_and_belongs_to_many :services, :join_table => :services_staffs
  has_many :availabilities

  #Query Interface....................................................
  default_scope { order(:name) }

  #Validations........................................................
  validates_presence_of :services

  #Callbacks..........................................................
  after_update :remove_availability, :remove_appointments, if: Proc.new { |staff| !staff.deleted_at? && staff.deleted_at_changed? }

  private

  def remove_availability
    availabilities.destroy_all
  end

  def remove_appointments
    appointments.where('starttime > ?', Time.now).destroy_all
  end

end
