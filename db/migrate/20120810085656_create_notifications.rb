class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :referrer_username
      t.references :profile
      t.references :comment
      
      t.timestamps
    end
  end
end