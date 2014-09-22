class AddActiveColumnToServicesAndStaff < ActiveRecord::Migration
  def change
    add_column :services_staffs, :active, :boolean, default: true
  end
end
