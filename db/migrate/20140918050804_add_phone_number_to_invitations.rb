class AddPhoneNumberToInvitations < ActiveRecord::Migration
  def change
    add_column :invitations, :phone_number, :string
  end
end
