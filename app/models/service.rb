class Service < ActiveRecord::Base
  
  default_scope { where(active: true) }
  validates :name, presence: true
  has_and_belongs_to_many :staffs, :join_table => :services_staffs
end
