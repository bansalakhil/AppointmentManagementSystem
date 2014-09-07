class Admin < User
  validates :email, format: { with: /\A\w+@\w+\.\w+\Z/,
                              message: 'is Invalid'}
  has_attached_file :avatar, :styles => { medium: "300x300>", thumb: "100x100>" },
                                          :default_url => "vinsol.jpg"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
