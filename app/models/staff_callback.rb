class StaffCallbacks

  def self.after_update(staff_member)
    Availability.delete_all(["staff_id = ? and start_time > ?", staff_member.id, DateTime.now.to_date])
  end
end