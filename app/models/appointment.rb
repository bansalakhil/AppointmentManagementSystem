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
  # FIX- Add inclusion validation on status
  # FIX- Please discuss
  validate :starttime, on: :create, if: :time_slot_available?
  # FIX- There is no validation for checking end_time before start_time
  # FIX- There is no validation for checking start_time in past

  def time_slot_available?
    # Pick all appointments of that day
    appointments = Appointment.where("starttime > ?", Time.now.beginning_of_day())
    outcome = appointments.all? do |var|
      # FIX- Use Time#between?
      !((self.starttime >= var.starttime && self.starttime < var.endtime) || (self.endtime >= var.starttime && self.endtime < var.endtime))
    end
    self.errors[:starttime] = 'coinsides with an existing appointment' unless outcome
    return outcome
  end

end