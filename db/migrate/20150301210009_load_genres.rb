class LoadGenres < ActiveRecord::Migration
  def change
  	tags = ['rock', 'pop', 'metal', 'blues', 'rap', 'jazz', 'hip-hop', 'country', 'reggae']
  	for tag_content in tags
  		Tag.create(content: tag_content)
  	end
  end
end
