class AddAttachmentLogoToSiteLayouts < ActiveRecord::Migration
  def self.up
    change_table :site_layouts do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :site_layouts, :logo
  end
end
