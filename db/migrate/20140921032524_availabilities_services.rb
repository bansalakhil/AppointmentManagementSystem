class AvailabilitiesServices < ActiveRecord::Migration
  def change
    create_table :availabilities_services, id: false do |t|
      t.belongs_to :availability
      t.belongs_to :service
      t.boolean :active, default: true
    end
  end
end