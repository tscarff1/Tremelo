class Band < ActiveRecord::Base
	validates :name, 
		presence: true,
		uniqueness: {case_sensitive: false}

	#Call as Band.delete_empty_bands to delete any bands without any members
	def self.delete_empty_bands
		bands = Band.all
		for band in bands
			if band.num_members == 0
				band.destroy
			end
		end
	end

	def num_members
		userbands = UserBand.where(band_id: self.id)
		return userbands.length
	end
end
