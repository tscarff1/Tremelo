class AddContentToGenres < ActiveRecord::Migration
  def change
    remove_column :genres, :content
    add_column :genres, :content, :string
  end
end
