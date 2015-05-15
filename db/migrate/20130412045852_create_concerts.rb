class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :name
      
      t.string :street_address
      t.string :zip
      
      t.decimal :people
      t.decimal :music
      t.decimal :venue
      t.decimal :atmosphere
      t.decimal :aggregate_score
      t.integer :number_of_votes
      t.integer :rank
      
      t.references :user
      t.references :genre
      t.references :venue
      t.references :city
      t.references :state
      t.references :country
      
      t.timestamps
    end
    
    add_index :concerts, :rank
  end
end
