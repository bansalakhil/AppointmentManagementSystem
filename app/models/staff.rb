class Staff < User

  #Constants.......................................................
  COLORS = ['#D7FF00', '#FF9B00', '#39FF00', '#FF00A4','#0051FF', '#00F3FF', '#6A00FF', '#FF002A', '#FBFF00']

  #Associations......................................................
  has_many :appointments, foreign_key: 'staff_id'
  has_and_belongs_to_many :services, :join_table => :services_staffs
  has_many :availabilities

  #Query Interface....................................................
  default_scope { order(:name) }

  #Validations........................................................
  validates_presence_of :services

  #Callbacks..........................................................
  before_create :generate_password
  before_create :assing_color
  after_create :send_welcome_email
  after_destroy :remove_availability

  private

  def remove_availability
    active_availabilities = availabilities.where('end_time > ?', Date.today)
    active_availabilities.each { |avail| avail.really_destroy! }
  end

  def generate_password
    self.password = SecureRandom.urlsafe_base64(5)
  end

  def send_welcome_email
    StaffWelcomeMailer.welcome_email(self).deliver
  end

  def assing_color
    self.color = COLORS.sample
  end

end
