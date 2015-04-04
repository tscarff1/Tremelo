class BandGenre < ActiveRecord::Base
  belongs_to :genre
  belongs_to :band

end
