class Status < ActiveRecord::Base
  has_many :appointments
end
