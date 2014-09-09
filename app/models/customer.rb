
class Customer < User

  #Associations......................................................
  has_one :appointment, foreign_key: 'customer_id'

  #Query Interface....................................................
  default_scope { order(:name) }

end