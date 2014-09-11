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
  validate :time_slot_available?, on: :create

  #Scopes.....................................................................
  scope :future, -> { where('starttime > :current_time', current_time: Time.now) }
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

  private

  def time_slot_available?
    # picks all appointment of that very day
    start_date = self.starttime.beginning_of_day()
    end_date = self.starttime.end_of_day()
    appointments = Appointment.in_between(start_date, end_date)
    appointments.any? do |appointment|
      overlapping?
    end
    self.errors[:starttime] = 'coinsides with an existing appointment' unless is_overlapping
  end

  def overlapping?
    (((self.starttime).between?(appointment.starttime, appointment.endtime)) || ((self.endtime).between?(appointment.starttime, appointment.endtime)) || 
        ((appointment.starttime).between?(self.starttime, self.endtime)) || ((appointment.endtime).between?(self.starttime, self.endtime)))
  end

  # def past_time?
  #   (self.starttime < 
  # end

end