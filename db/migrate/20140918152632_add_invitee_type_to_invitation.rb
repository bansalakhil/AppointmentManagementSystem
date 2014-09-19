class AddInviteeTypeToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :invitee_type, :string
  end
end
