class Service < ActiveRecord::Base
  #Associations..................................................
  has_and_belongs_to_many :staffs, :join_table => :services_staffs
  
  #Query Interface...............................................
  default_scope { where(active: true) }

  #Validations...................................................
  validates :name, presence: true
end
