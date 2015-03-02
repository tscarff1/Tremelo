class LoadTags < ActiveRecord::Migration
  def change
  	Tag.delete_all
  	UserTags.delete_all
  	tags = ['saxophone', 'guitar', 'vocals', 'drums', 'flute', 'fiddle', 'violin', 'banjo',
  	'piano', 'keyboard', 'harmonica', 'bass', 'cello']
  	for tag_content in tags
  		Tag.create(content: tag_content)
  	end
  end
end
