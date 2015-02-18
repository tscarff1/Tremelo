class AddVideoLinkToBand < ActiveRecord::Migration
  def change
    add_column :bands, :video_link, :string
    add_column :bands, :video_link_html, :string
  end
end
