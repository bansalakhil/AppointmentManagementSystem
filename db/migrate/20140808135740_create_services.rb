class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :slot_window, default: 15
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
