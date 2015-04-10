class BandGenre < ActiveRecord::Base
	validates :band_id, uniqueness: {scope: :genre_id}
  belongs_to :genre
  belongs_to :band
end
