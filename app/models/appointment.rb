class Appointment < ActiveRecord::Base
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :staff, class_name: 'User', foreign_key: 'staff_id'
  belongs_to :status
  has_one :cancellation
  validates :disease, presence: true
  validate :appointment_datetime, on: :create, if: :time_slot_available?

  def time_slot_available?
    appointments = Appointment.where("appointment_datetime > ?", DateTime.now.to_date)
    outcome = appointments.all? do |apt|
      end_time =  apt.appointment_datetime + (apt.doctor.doctors_information.slot_window * apt.slots * 60)
      !(self.appointment_datetime >= apt.appointment_datetime && self.appointment_datetime < end_time)
    end
    self.errors[:appointment_datetime] = 'coinsides with an existing appointment' unless outcome
    return outcome
  end

end