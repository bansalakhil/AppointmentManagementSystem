class Availability < ActiveRecord::Base
  acts_as_paranoid
  
  # Associations.................................................
  belongs_to :service
  belongs_to :staff

  # Validations..................................................
  # validates :start_time, uniqueness: { scope: :staff_id }, presence: true
  validates :start_time, :end_time, :start_date, :end_date, :service_id, :staff_id, presence: true
  validate :time_period, on: :create
  validate :for_future, on: :create

  #Query Interface...............................................
  default_scope { order(:start_time) }

  private

  def time_period
    error[:base] = 'Invalid Time' unless (start_time < end_time) && (start_date < end_date)
  end

  def for_future
    error[:base] = 'Invalid Time' unless (start_date >= Time.now.to_date)
  end

end
