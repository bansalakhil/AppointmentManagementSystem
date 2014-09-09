class Appointment < ActiveRecord::Base
  STATUSES = { '1' => 'pending', '2' => 'in_process', '3' => 'cancelled', '4' => 'done' }

  #Associations...............................................................
  belongs_to :customer, class_name: 'User', foreign_key: 'customer_id'
  belongs_to :staff, class_name: 'User', foreign_key: 'staff_id'
  belongs_to :service

  #Validations................................................................
  validates :description, presence: true
  validate :starttime, on: :create, if: :time_slot_available?

  def time_slot_available?
    # Pick all appointments of that day
    appointments = Appointment.where("starttime > ?", Time.now.beginning_of_day())
    outcome = appointments.all? do |var|
      !((self.starttime >= var.starttime && self.starttime < var.endtime) || (self.endtime >= var.starttime && self.endtime < var.endtime))
    end
    self.errors[:starttime] = 'coinsides with an existing appointment' unless outcome
    return outcome
  end

end