class SiteLayout < ActiveRecord::Base
  #Associations......................................................
  has_attached_file :logo, :styles => { thumb: "60x60>" }, :default_url => "logo/vinsol.jpg"
  has_attached_file :background, :styles => { full: "700x700>" }, :default_url => "5.jpg"

  #Validations........................................................
  validates_attachment_content_type :logo, :content_type => /\Aimage\/.*\Z/
  validates_attachment_content_type :background, :content_type => /\Aimage\/.*\Z/

end
