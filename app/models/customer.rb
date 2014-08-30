require 'invitation_callbacks'

class Customer < User
  # has_one :appointment, foreign_key: 'customer_id'
  # accepts_nested_attributes_for :appointment

  #Query Interface....................................................
  default_scope { order(:name) }

  #Callbacks..........................................................
  # after_save InvitationCallbacks
end