class SiteLayout < ActiveRecord::Base
  #Associations......................................................
  has_attached_file :logo, :styles => { thumb: "60x60>" }, :default_url => "logo/vinsol.jpg"
  has_attached_file :background, :styles => { full: "1300x1300!" }, :default_url => "background/defaultBG.jpg"

  #Validations........................................................
  # FIX- Can we write following validations in one line?
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

end
