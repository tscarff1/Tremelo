class BandMusic < ActiveRecord::Base
  validates :embed_html, presence: true
  validates :name, presence: true
  belongs_to :band


end
