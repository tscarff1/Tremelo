class LoadGenres < ActiveRecord::Migration
  def change
  	genres = ['pop', 'rock', 'blues', 'metal', 'jazz', 'hip-hop', 'rap', 'reggae', 'country', 'classical', 'alternative']
  	for genre_content in genres
  		Genre.create(content: genre_content)
  	end
  end
end
