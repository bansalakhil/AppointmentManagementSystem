class AddRemarkToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :remark, :text
  end
end
