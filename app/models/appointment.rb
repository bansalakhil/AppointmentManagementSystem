class Appointment < ActiveRecord::Base
  acts_as_paranoid

  STATUSES = { '1' => 'pending', '2' => 'in_process', '3' => 'cancelled', '4' => 'done' }

  #Associations...............................................................
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :staff, class_name: 'User', foreign_key: 'staff_id'
  belongs_to :service

  #Validations................................................................
  validates :service_id, :staff_id, :customer_id,:description, presence: :true
  validate :staff_available, on: [:create, :update]
  validate :time_slot_available, on: [:create, :update]
  validate :past_time?, on: [:create, :update]
  validate :check_service_slot_time, on: [:create, :update]

  #Scopes.....................................................................
  default_scope { order('starttime desc')}
  scope :future, -> { where('starttime > :current_time', current_time: Time.now) }
  scope :for_customer, ->(customer_id) { where('customer_id = :customer', customer: customer_id) }
  scope :for_staff, ->(staff_id) { where('staff_id = :staff', staff: staff_id) }
  scope :past, -> { where('endtime < :current_time', current_time: Time.now) }
  scope :pending, -> { where('status = 1')}
  scope :in_process, -> { where('status = 2')}
  scope :cancelled, -> { where('status = 3')}
  scope :done, -> { where('status = 4')}
  scope :in_between, ->(starts, ends) { where(starttime: (starts..ends))}
  scope :by_timerange, ->(start_time, end_time) { where('
                          (starttime >= :start_time and endtime <= :end_time) or
                          (starttime >= :start_time and endtime > :end_time and starttime <= :end_time) or
                          (starttime <= :start_time and endtime >= :start_time and endtime <= :end_time) or
                          (starttime <= :start_time and endtime > :end_time)',
                          start_time: start_time, end_time: end_time)
                        }

  #Callbacks..........................................................................
  before_save :set_pending

  def overlapping_with?(starts_at, ends_at)

    (((starttime).between?(starts_at, ends_at)) || ((endtime).between?(starts_at, ends_at)) || 
        ((starts_at).between?(starttime, endtime)) || ((ends_at).between?(starttime, endtime)))
  end

  private

  def time_slot_available
    # picks all appointment of that very day
    start_date = starttime.beginning_of_day()
    end_date = starttime.end_of_day()
    starts_at = starttime
    ends_at = endtime
    appointments = self.class.where('service_id = ? and staff_id = ?',service_id, staff_id).in_between(start_date, end_date).where.not(id: id)
    overlapping = appointments.any? { |apt| apt.overlapping_with?(starts_at, ends_at) }
    errors[:base] = 'Appointment coinsides with an existing appointment' if overlapping
  end

  def staff_available
    availability = staff.availabilities.where(service_id: service_id)
          .where('start_date <= :app_start and end_date >= :app_end', app_start: starttime.to_date, app_end: endtime.to_date )
          .where('start_time <= :app_start and end_time >= :app_end', app_start: starttime.strftime('%H:%M'), app_end: endtime.strftime('%H:%M') )
          .first
    errors[:base] = "#{ staff.name } is not available" unless availability

  end

  def set_pending
    status = 1
  end

  def past_time?
    errors[:base] = 'This time has already passed' if (starttime < Time.now)
  end

  def check_service_slot_time
    errors[:base] = "This appointment can be booked for minimum #{ service.slot_window } mins"  unless service.slot_window <= (endtime - starttime)/60 
  end

end