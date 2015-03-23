class AddDobToUser < ActiveRecord::Migration
  def up
  	add_column :users, :dob, :string
  end

  def down
  	remove_column :users, :dob, :string
  end
end
