class StaffCallbacks

  def self.after_update(staff_member)
    Availability.delete_all(["staff_id = ?", staff_member.id])
  end
end