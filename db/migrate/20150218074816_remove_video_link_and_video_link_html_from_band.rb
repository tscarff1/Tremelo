class RemoveVideoLinkAndVideoLinkHtmlFromBand < ActiveRecord::Migration
  def change
    remove_column :bands, :video_link, :string
    remove_column :bands, :video_link_html, :string
  end
end
