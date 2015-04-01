class BandMusic < ActiveRecord::Base
  validates :embed_html, presence: true
  validates :music_name, presence: true
  belongs_to :band


end
