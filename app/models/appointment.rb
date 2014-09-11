class Appointment < ActiveRecord::Base
  # FIX-
  #   Rename status_id to status in table
  #   Fix default value for status. It should be set to 1 by default.

  STATUSES = { '1' => 'pending', '2' => 'in_process', '3' => 'cancelled', '4' => 'done' }

  #Associations...............................................................
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :staff, class_name: 'User', foreign_key: 'staff_id'
  belongs_to :service

  #Validations................................................................
  # FIX- Add validations for start_time, end_time, customer_id, staff_id, service_id
  validates :description, presence: true
  validate :staff_available, on: :create
  validate :time_slot_available, on: :create
  validates :service_id, :staff_id, :customer_id, presence: :true
  validate :past_time?, on: :create

  #Scopes.....................................................................
  scope :future, -> { where('starttime > :current_time', current_time: Time.now) }
  scope :for_customer, -> { where('customer_id = :customer', customer: customer_id) }
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
    appointments = self.class.where('service_id = ? and staff_id = ?',service_id, staff_id).in_between(start_date, end_date)
    not_overlapping = appointments.any? { |apt| apt.overlapping_with?(starts_at, ends_at) }
    self.errors[:starttime] = 'coinsides with an existing appointment' if not_overlapping
  end

  def staff_available
    availability = staff.availabilities.where(service_id: service_id)
          .where('start_date <= :app_start and end_date >= :app_end', app_start: starttime.to_date, app_end: endtime.to_date ).where('start_time <= :app_start and end_time >= :app_end', app_start: starttime.strftime('%H:%M'), app_end: endtime.strftime('%H:%M') ).first
    errors[:base] = 'Staff not available' unless availability

  end


  def past_time?
    # past = starttime < Time.now
    errors[:base] = 'This time has already passed' if (starttime < Time.now)
  end

end