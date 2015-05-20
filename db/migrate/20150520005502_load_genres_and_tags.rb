class LoadGenresAndTags < ActiveRecord::Migration
  def change
  	genres = ['pop', 'rock', 'blues', 'metal', 'jazz', 'hip-hop', 'rap', 'reggae', 'country', 'classical', 'alternative']
  	for genre_content in genres
  		Genre.create(content: genre_content)
  	end
  	tags = ['saxophone', 'guitar', 'vocals', 'drums', 'flute', 'fiddle', 'violin', 'banjo',
  	'piano', 'keyboard', 'harmonica', 'bass', 'cello']
  	for tag_content in tags
  		Tag.create(content: tag_content)
  	end
  end
end
