class BandGenre < ActiveRecord::Base
<<<<<<< HEAD
	validates :band_id, uniqueness: {scope: :genre_id}
=======
  belongs_to :genre
  belongs_to :band

>>>>>>> b113bb9b6c25a2a43d1c7cf2f297d48cba41fe2f
end
