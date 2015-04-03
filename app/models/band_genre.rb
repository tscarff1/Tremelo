class BandGenre < ActiveRecord::Base
	validates :band_id, uniqueness: {scope: :genre_id}
end
