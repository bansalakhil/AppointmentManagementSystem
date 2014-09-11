
class Customer < User

  #Associations......................................................
  has_many :appointments, foreign_key: 'customer_id'

  #Query Interface....................................................
  default_scope { order(:name) }

end