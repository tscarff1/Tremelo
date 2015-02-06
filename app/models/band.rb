class Band < ActiveRecord::Base
	validates :name, 
		presence: true,
		uniqueness: true

	def num_members
		userbands = UserBand.where(band_id: self.id)
		return userbands.length
	end

end
