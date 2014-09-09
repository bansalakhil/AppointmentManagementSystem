
class Customer < User

  #Associations......................................................
  # FIX- has_one? Please explain.
  has_one :appointment, foreign_key: 'customer_id'

  #Query Interface....................................................
  default_scope { order(:name) }

end