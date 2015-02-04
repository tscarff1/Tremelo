class Band < ActiveRecord::Base
	validates :name, 
		presence: true,
		uniqueness: true

	before_save :downcase_name

end
