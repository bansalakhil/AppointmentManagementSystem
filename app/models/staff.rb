class Staff < User
  # has_many :appointments, foreign_key: 'staff_id'
  # has_one :staffs_information, class_name: 'User', foreign_key: 'staff_id'
  has_and_belongs_to_many :services, foreign_key: :user_id
  accepts_nested_attributes_for :services
  has_many :availabilities
end