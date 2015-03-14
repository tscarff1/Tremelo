class CreateBandMusics < ActiveRecord::Migration
  def change
    create_table :band_musics do |t|
      t.integer :band_id
      t.string :embed_html
      t.string :name

      t.timestamps
    end
  end
end
