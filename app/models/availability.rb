class Availability < ActiveRecord::Base
  belongs_to :service
  belongs_to :staff
  validates :start_time, uniqueness: { scope: :staff_id }, presence: true
  validates :end_time, :start_date, :end_date, presence: true
end
