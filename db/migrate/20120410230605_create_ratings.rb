class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :people_score
      t.integer :music_score
      t.integer :venue_score
      t.integer :atmosphere_score
      
      t.references :concert
      t.references :user

      t.timestamps
    end
  end
end
