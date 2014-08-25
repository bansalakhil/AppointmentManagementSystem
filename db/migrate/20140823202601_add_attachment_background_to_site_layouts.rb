class AddAttachmentBackgroundToSiteLayouts < ActiveRecord::Migration
  def self.up
    change_table :site_layouts do |t|
      t.attachment :background
    end
  end

  def self.down
    remove_attachment :site_layouts, :background
  end
end
