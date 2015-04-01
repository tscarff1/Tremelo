class Genre < ActiveRecord::Base
	validates :content, presence: true,
                    uniqueness: {case_sensitive: false},
                    format: {
                      with: /^[a-zA-Z]+$/, multiline: true #Allow only alphabetical characters
                    }
    before_save :downcase_content

    #Methods to return what the label color should be
  def downcase_content
    self.content = content.downcase
  end

	def get_red
		# 122 is the ascii value of 'z'
		if(!content.nil?)
			red = 55 * (5 - id % 10)/10 + ((content[0].ord/100) * 256).to_i
		end
	end

	def get_green
		if !content.nil?
		
				green = (((content[-1].ord + content[1].ord) + (id % 4) * 50)/500.0 * 255 - 20).abs.to_i
		
		end
	end

	def get_blue
		if !content.nil?
			blue = (((content[1].ord + content[0].ord) * (id % 3))/1100.0 * 255 - 60).abs.to_i
		end
	end
end
