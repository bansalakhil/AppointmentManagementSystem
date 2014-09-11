class SiteLayout < ActiveRecord::Base
  #Associations......................................................
  has_attached_file :logo, :styles => { thumb: "60x60>" }, :default_url => "logo/vinsol.jpg"
  has_attached_file :background, :styles => { full: "1300x1350!" }, :default_url => "background/defaultBG.jpg"

  #Validations........................................................
  validates_attachment_content_type [:logo, :background], :content_type => /\Aimage\/.*\Z/
end
