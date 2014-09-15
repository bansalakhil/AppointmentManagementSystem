class Service < ActiveRecord::Base
  acts_as_paranoid
  
  #Associations..................................................
  # FIX- No need to specify join_table
  has_and_belongs_to_many :staffs, :join_table => :services_staffs
  
  #Query Interface...............................................
  default_scope { order(:name) }

  #Validations...................................................
  validates :name, uniqueness: { case_sensitive: false }, presence: true
end
