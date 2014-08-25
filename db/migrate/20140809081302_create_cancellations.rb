class CreateCancellations < ActiveRecord::Migration
  def change
    create_table :cancellations do |t|
      t.string :reason
      t.integer :cancelled_by #user id
      t.datetime :created_at
    end
  end
end
