class MakeAllowedEmbedCodeLonger < ActiveRecord::Migration
  def up
  	change_column :band_musics, :embed_html, :text
  end

  def down
  	change_column :band_musics, :embed_html, :string
  end
end
