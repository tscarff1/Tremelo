class Tag < ActiveRecord::Base
	validates :content, presence: true,
                    uniqueness: {case_sensitive: false}
    before_save :downcase_content
	
    def downcase_content
    	self.content = content.downcase
    end


    #Methods to return what the label color should be

	def get_red
		# 122 is the ascii value of 'z'
		if(!content.nil?)
			red = (content[0].ord/122.0 * 255).to_i.to_s(16)
		end
	end

	def get_green
		# 122 is the ascii value of 'z'
		if !content.nil?
			green = (content[-1].ord/122.0 * 255).to_i.to_s(16)
		end
	end

	def get_blue
		#25 is the max difference between the first and last characters
		if !content.nil?
			blue = ((content[-1].ord - content[0].ord).abs / 25.0 * 255).to_i.to_s(16)
		end
	end

	def get_color
		return "##{get_red}#{get_green}#{get_blue}"
	end
end
