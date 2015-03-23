class AddDobToBands < ActiveRecord::Migration
  def up
  	add_column :bands, :dob, :string
  end

  def down
  	remove_column :bands, :dob
  end
end
