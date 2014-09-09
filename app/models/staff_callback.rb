class StaffCallbacks

  # FIX- Move this code to Staff model as it is being used there only.
  def self.after_update(staff_member)
    Availability.delete_all(["staff_id = ? and start_time > ?", staff_member.id, DateTime.now.to_date])
  end
end