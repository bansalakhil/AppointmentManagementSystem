class Service < ActiveRecord::Base
  acts_as_paranoid
  
  #Associations..................................................
  # FIX- No need to specify join_table
  has_and_belongs_to_many :staffs, :join_table => :services_staffs
  has_many :availabilities
  has_many :appointments

  #Callbacks.....................................................
  # before_destroy :check_associated_availabilities_appointments
  after_destroy :delete_service_from_availability
  
  #Query Interface...............................................
  default_scope { order(:name) }

  #Validations...................................................
  validates :name, uniqueness: { case_sensitive: false }, presence: true

  #Private Methods.................................................
  private

  def delete_service_from_services_staffs
    
  end

end
