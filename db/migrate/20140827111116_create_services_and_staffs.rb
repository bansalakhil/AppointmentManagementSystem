class CreateServicesAndStaffs < ActiveRecord::Migration
  def change
    create_table :services_staffs, id: false do |t|
      t.belongs_to :staff
      t.belongs_to :service
    end
  end
end
