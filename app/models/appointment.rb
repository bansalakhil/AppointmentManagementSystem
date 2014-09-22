class Appointment < ActiveRecord::Base
  acts_as_paranoid

  STATUSES = { '1' => 'pending', '2' => 'in_process', '3' => 'cancelled', '4' => 'done' }

  #Associations...............................................................
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :staff, class_name: 'User', foreign_key: 'staff_id'
  belongs_to :service

  #Validations................................................................
  validates :service_id, :customer_id, presence: :true
  validate :time_slot_available, on: [:create, :update], allow_blank: true
  validate :staff_available, on: [:create, :update], allow_blank: true
  validate :past_time?, on: [:create, :update], allow_blank: true
  validate :check_service_slot_time, on: [:create, :update], allow_blank: true

  #Scopes.....................................................................
  default_scope { order('starttime desc')}
  scope :future, -> { where('starttime > ?', Time.now) }
  scope :for_customer, ->(customer_id) { where('customer_id = ?', customer_id) }
  scope :for_staff, ->(staff_id) { where('staff_id = ?', staff_id) }
  scope :past, -> { where('endtime < ?', Time.now) }
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
  before_save :get_available_staff
  before_save :set_appointment_title
  after_save :send_booking_mail
  after_destroy :send_cancellation_mail

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
    if staff
      availability = staff.availabilities.where(service_id: service_id)
            .where('start_date <= :app_start and end_date >= :app_end', app_start: starttime.to_date, app_end: endtime.to_date )
            .where('start_time <= :app_start and end_time >= :app_end', app_start: starttime.strftime('%H:%M'), app_end: endtime.strftime('%H:%M') )
            .first
      errors[:base] = "#{ staff.name } is not available" unless availability
    end
  end

  def set_pending
    self.status = 1
  end

  def past_time?
    errors[:base] = 'This time has already passed' if (starttime < Time.now)
  end

  def check_service_slot_time
    if service
      errors[:base] = "This appointment can be booked for minimum #{ service.slot_window } mins"  unless service.slot_window <= (endtime - starttime)/60
    end
  end

  def send_booking_mail
    BookingConfirmationMailer.booking_email(self).deliver
  end

  def send_cancellation_mail
    AppointmentCancellationMailer.cancellation_email(self).deliver
  end

  def get_available_staff
    if staff_id.nil?
      app_start_time = "#{starttime.hour}:#{starttime.min}"
      app_end_time = "#{endtime.hour}:#{endtime.min}"
      availabilities = Availability.where('(start_date <= :app_start_date) and (end_date >= :app_end_date) and
                        (start_time <= :app_start_time) and (end_time >= :app_end_time) and
                        (service_id = :service)',
                        app_start_date: starttime.to_date, app_end_date: endtime.to_date,
                        app_start_time: app_start_time, app_end_time: app_end_time,
                        service: service_id)
      available_staff = []
      availabilities.each {|avail| available_staff << avail.staff_id }
      #choose a staff randomly
      if available_staff.first
        self.staff_id = available_staff.sample
      else
        errors[:base] = 'No staff for this service in this time period'
        return false
      end
    end
  end

  def set_appointment_title
    self.title = staff.name + '--' + service.name
  end

end