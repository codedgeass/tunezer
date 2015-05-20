class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :url
      
      t.references :concert
      
      t.timestamps
    end
  end
end
