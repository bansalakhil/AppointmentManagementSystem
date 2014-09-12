class AddDeletedAtColumnToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :deleted_at, :datetime
  end
end
