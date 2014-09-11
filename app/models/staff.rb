
class Staff < User
  has_many :appointments, foreign_key: 'staff_id'
  
  #Callbacks..........................................................
  after_update :remove_availability, if: Proc.new { |staff| !staff.active? && staff.active_changed? }

  #Associations......................................................
  has_and_belongs_to_many :services, :join_table => :services_staffs
  has_many :availabilities

  #Query Interface....................................................
  default_scope { where(active: true).order(:name) }

  #Validations........................................................
  validates_presence_of :services

  private

  def remove_availability
    Availability.delete_all(["staff_id = ?", id])
  end

end
