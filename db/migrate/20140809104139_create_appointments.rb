class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :staff_id
      t.integer :customer_id
      t.integer :service_id
      t.datetime :starttime, :endtime
      t.integer :status_id, default: 1
      t.string :description
      t.timestamps
    end
  end
end
