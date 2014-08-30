class InvitationCallbacks
  def self.after_save(user)
    user.invite!
  end
end