# FIX- Remove this. Add it as a field in appointments table.
class Status < ActiveRecord::Base
  has_many :appointments
end
