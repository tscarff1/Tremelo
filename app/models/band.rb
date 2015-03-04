class Band < ActiveRecord::Base
	validates :name, 
		presence: true,
		uniqueness: {case_sensitive: false}

	has_attached_file :profile_picture,  :styles => { medium: "200x200#", thumb: "100x100#"}
	validates_attachment_content_type :profile_picture, :content_type => /\Aimage\/.*\Z/

	geocoded_by :full_address
	after_validation :geocode, :if => :full_address_changed?

	SOUNDCLOUD_CLIENT_ID = "957c34cadbaefe85378c2014b12227a5"
	SOUNDCLOUD_CLIENT_SECRET = "71cecfc3f8620b57e03aec7b2b3e2cc3"

	def self.SOUNDCLOUD_CLIENT_ID
		SOUNDCLOUD_CLIENT_ID
	end

	def self.soundcloud_stuff
		# register a client with YOUR_CLIENT_ID as client_id_
		client = SoundCloud.new(:client_id => SOUNDCLOUD_CLIENT_ID)
		# get 10 hottest tracks
		tracks = client.get('/tracks', :limit => 10, :order => 'hotness')
		# print each link
		
	end

	def self.printsoundcloud
		tracks.each do |track|
	  		puts track.permalink_url
		end
	end

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
