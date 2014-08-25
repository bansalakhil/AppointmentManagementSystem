class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :doctor_id
      t.integer :patient_id
      t.datetime :appointment_datetime
      t.integer :slots, default: 1
      t.integer :status_id
      t.string :disease
      t.timestamps
    end
  end
end
