class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :address
      t.integer :phone_number
      t.string :email
      t.string :designation
      t.string :type
    end
  end
end
