class Band < ActiveRecord::Base
	validates :name, 
		presence: true,
		uniqueness: {case_sensitive: false}

	has_attached_file :profile_picture,  :styles => { medium: "200x200#", thumb: "100x100#"}
	validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/

	geocoded_by :full_address
	after_validation :geocode, :if => :full_address_changed?

	#Call as Band.delete_empty_bands to delete any bands without any members
	def self.delete_empty_bands
		bands = Band.all
		for band in bands
			if band.num_members == 0
				delete_band(band.id)
			end
		end
	end

	def delete_band(id)
		if (Band.exists?(id))
			Band.find(id).destroy
		end
		#Now we delete associations to the band
		for userband in UserBand.where(band_id: id)
			userband.destroy
		end
	end

	def num_members
		userbands = UserBand.where(band_id: self.id)
		return userbands.length
	end
end
