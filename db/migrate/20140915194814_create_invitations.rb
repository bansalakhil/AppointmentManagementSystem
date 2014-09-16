class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.string :name
      t.string :email
      t.string :invitation_token
      t.datetime :invitation_accepted_at
      t.timestamps
    end
  end
end
