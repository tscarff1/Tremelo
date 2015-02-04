class Band < ActiveRecord::Base
	validates :name, 
		presence: true,
		uniqueness: true

	before_save :downcase_name

	def downcase_name
		self.name = name.downcase
	end
end
