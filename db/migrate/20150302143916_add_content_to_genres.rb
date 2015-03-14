class AddContentToGenres < ActiveRecord::Migration
  def change
 	create_table :genres do |t|
      t.timestamps	
  	end
    add_column :genres, :content, :string
  end
end
