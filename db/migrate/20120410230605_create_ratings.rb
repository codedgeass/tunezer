class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :people
      t.integer :music
      t.integer :venue
      t.integer :atmosphere
      
      t.references :concert
      t.references :user

      t.timestamps
    end
  end
end
