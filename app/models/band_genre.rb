class BandGenre < ActiveRecord::Base
<<<<<<< HEAD
	validates :band_id, uniqueness: {scope: :genre_id}
=======
  belongs_to :genre
  belongs_to :band

>>>>>>> sean_test
end
