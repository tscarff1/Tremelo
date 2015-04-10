class BandGenre < ActiveRecord::Base
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> 15be59ec5eb0654de8095f1972c2b504bd7557e5
	validates :band_id, uniqueness: {scope: :genre_id}
  belongs_to :genre
  belongs_to :band

<<<<<<< HEAD
>>>>>>> b113bb9b6c25a2a43d1c7cf2f297d48cba41fe2f
=======
>>>>>>> 15be59ec5eb0654de8095f1972c2b504bd7557e5
end
