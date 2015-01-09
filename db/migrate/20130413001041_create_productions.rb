class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
      t.string :name
      t.string :genre
      t.string :category
      t.decimal :people
      t.decimal :music
      t.decimal :venue
      t.decimal :atmosphere
      t.decimal :aggregate_score
      t.integer :number_of_votes
      t.integer :rank
      
      t.timestamps
    end
    
    add_index :productions, :rank
  end
end
