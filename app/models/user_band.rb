class UserBand < ActiveRecord::Base
	validates :band_id, presence: true
	validates :user_id, presence: true, uniqueness:{scope: :band_id}

	def destroy_duplicates
		userbands = UserBand.where(band_id: band_id, user_id: user_id)
		for dup in userbands
			if dup.id != id
				dup.destroy
			end
		end
	end
end
