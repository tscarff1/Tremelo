class Tag < ActiveRecord::Base
	# to display a tag, use the display partial with locals: genre
	validates :content, presence: true,
                    uniqueness: {case_sensitive: false},
                    format: {
                      with: /^[a-zA-Z]+$/, multiline: true #Allow only alphabetical characters
                    }
    before_save :downcase_content
	 has_many :user_tags
   has_many :users, through: :user_tags
    def downcase_content
    	self.content = content.downcase
    end


    #Methods to return what the label color should be

	def get_red
		# 122 is the ascii value of 'z'
		if(!content.nil?)
			red = ((content[0].ord * 2.5 * (id % 3) )/300.0 * 255).to_i
		end
	end

	def get_green
		if !content.nil?
			green = (((content[-1].ord + content[1].ord) * 1.5 * (id % 10)/5)/600.0 * 255).abs.to_i
		end
	end

	def get_blue
		if !content.nil?
			blue = (((content[1].ord + content[0].ord)* 2 * (id % 4))/1100.0 * 155 - 40).abs.to_i
		end
	end
end
