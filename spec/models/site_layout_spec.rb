require 'rails_helper'

RSpec.describe SiteLayout, :type => :model do

  context 'should have an attached file' do
    it { should have_attached_file(:logo) }
    it { should have_attached_file(:background) }
  end

  context 'attachement type should be either jpeg' do
    it do
     should validate_attachment_content_type(:logo).
               allowing('image/png', 'image/gif')
    end
  end

end
