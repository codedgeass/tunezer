class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :real_name
      t.integer :age
      t.string :hometown
      t.string :favorite_artists
      t.string :favorite_songs
      t.string :messages
      t.references :user

      t.timestamps
    end
  end
end
