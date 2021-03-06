class Availability < ActiveRecord::Base
  acts_as_paranoid
  
  # Associations.................................................
  belongs_to :service
  # has_and_belongs_to_many :services
  belongs_to :staff

  # Validations..................................................
  validates :start_time, :end_time, :start_date, :end_date, :service_id, :staff_id, presence: true
  validate :time_period, on: [:create, :edit]
  validate :for_future, on: [:create, :edit]
  validate :busy, on: [:create, :edit]

  #Query Interface...............................................
  default_scope { order('deleted_at asc') }

  #Public methods................................................

  def overlapping_with?(starts_at, ends_at)

    (((start_time).between?(starts_at, ends_at)) || ((end_time).between?(starts_at, ends_at)) || 
        ((starts_at).between?(start_time, end_time)) || ((ends_at).between?(start_time, end_time)))
  end

  #Private methods................................................
  private

  def time_period
    errors[:base] = 'Invalid time period chosen' unless (start_time < end_time) && (start_date <= end_date)
  end

  def for_future
    start_time_in_sec = (start_time.hour * 3600) + (start_time.min * 60)
    time_now_in_sec = (Time.now.hour * 3600) + (Time.now.min * 60)
    errors[:base] = 'Availability cannot be booked for past dates' if ((start_date < Date.today) || (start_date == Date.today && start_time_in_sec < time_now_in_sec))
  end

  def busy
    #staff and time pair should be unique
    day_begin = start_time.beginning_of_day()
    day_end = start_time.end_of_day()
    avaialability_starts_at = start_time
    avaialability_ends_at = end_time
    schedule_list = self.class.where('staff_id = ? and service_id = ? and start_time between ? and ?', staff_id, service_id, day_begin, day_end)
    overlapping = schedule_list.any? { |availability| availability.overlapping_with?(avaialability_starts_at, avaialability_ends_at) }
    self.errors[:base] = " #{ self.staff.name.capitalize } is busy for this time period " if overlapping

  end

end
