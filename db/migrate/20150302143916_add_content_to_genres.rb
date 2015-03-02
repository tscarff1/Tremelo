class AddContentToGenres < ActiveRecord::Migration
  def change
    add_column :genres, :content, :string
  end
end
