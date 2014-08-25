class ChangePhoneNumberFormat < ActiveRecord::Migration
  def up
    change_column :users, :phone_number, :bigint
  end

  def down
    change_column :users, :phone_number, :integer
  end
end
