class AddDeletedAtColumnToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :deleted_at, :datetime
  end
end
