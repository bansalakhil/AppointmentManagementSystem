class CreateSiteLayouts < ActiveRecord::Migration
  def change
    create_table :site_layouts do |t|

      t.timestamps
    end
  end
end
