class AddVideoNameToBandVideo < ActiveRecord::Migration
  def change
    add_column :band_videos, :video_name, :string
  end
end
