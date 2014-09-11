class CreateUsers < ActiveRecord::Migration
  def change
    #devise itself adds an email id for user
    create_table :users do |t|
      t.string :name
      t.string :type, default: 'Customer'
      t.boolean :active, default: true
    end
  end
end
