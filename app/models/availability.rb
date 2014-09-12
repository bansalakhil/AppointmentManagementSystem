class Availability < ActiveRecord::Base
  acts_as_paranoid
  
  # Associations.................................................
  belongs_to :service
  belongs_to :staff

  # Validations..................................................
  validates :start_time, :end_time, :start_date, :end_date, :service_id, :staff_id, presence: true
  validates :start_time, :end_time, uniqueness: { scope: :staff_id }, allow_blank: true
  validate :time_period, on: [:create, :edit] #also put for edit
  validate :for_future, on: [:create, :edit]

  #Query Interface...............................................
  default_scope { order('deleted_at asc') }

  private

  def time_period
    errors[:base] = 'Invalid time period given' unless (start_time < end_time) && (start_date < end_date)
  end

  def for_future
    errors[:base] = 'Availability cannot be booked for past dates' unless (start_date >= Time.now.to_date)
  end

  def unique_availabilities
    #staff and time pair should be unique
    availabilities = self.class.all

  end

end
