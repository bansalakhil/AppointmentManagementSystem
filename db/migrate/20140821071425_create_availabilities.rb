class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.integer :staff_id
      t.integer :service_id
      t.time :start_time
      t.time :end_time
      t.date :start_date
      t.date :end_date
    end
  end
end
