class Availability < ActiveRecord::Base
  # Associations.................................................
  belongs_to :service
  belongs_to :staff

  # Validations..................................................
  # validates :start_time, uniqueness: { scope: :staff_id }, presence: true
  validates :start_time, :end_time, :start_date, :end_date, presence: true

  #Query Interface...............................................
  default_scope { order(:start_time) }

end
