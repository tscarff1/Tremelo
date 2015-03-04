class LoadTags < ActiveRecord::Migration
  def change
  	tags = ['saxophone', 'guitar', 'vocals', 'drums', 'flute', 'fiddle', 'violin', 'banjo',
  	'piano', 'keyboard', 'harmonica', 'bass', 'Cello']
  	for tag_content in tags
  		Tag.create(content: tag_content)
  	end
  end
end
