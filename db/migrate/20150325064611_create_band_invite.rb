class CreateBandInvite < ActiveRecord::Migration
  def up
    	add_column :notifications, :band_id, :integer
  end
  def down
  		remove_column :notifications, :band_id
  end
end
