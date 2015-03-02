class AddContentToTags < ActiveRecord::Migration
  def change
    remove_column :tags, :content
    add_column :tags, :content, :string
  end
end
