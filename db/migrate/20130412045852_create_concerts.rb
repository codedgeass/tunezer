class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :name
      t.string :genre
      t.decimal :people
      t.decimal :music
      t.decimal :venue
      t.decimal :atmosphere
      t.decimal :aggregate_score
      t.integer :number_of_votes
      t.integer :rank
      
      t.timestamps
    end
    
    add_index :concerts, :rank
  end
end
