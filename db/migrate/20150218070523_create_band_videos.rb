class CreateBandVideos < ActiveRecord::Migration
  def change
    create_table :band_videos do |t|
      t.integer :band_id
      t.string :video_link
      t.string :video_link_html

      t.timestamps
    end
  end
end
