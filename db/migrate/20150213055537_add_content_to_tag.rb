class AddContentToTag < ActiveRecord::Migration
  def change
    add_column :tags, :content, :string
  end
end
