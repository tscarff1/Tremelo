class Notification < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, uniqueness: true

  # Special Characters List
  # none - Generic Notification (ie, band uploaded a video)
  # %B Band Invitation
  # %b user requesting membership to a band
  # %m Message
  # %M Formatted message (Just an idea)
  #  

  def is_band_invite?
  	if !special_chars.nil? && special_chars.include?("%B")
  		return true
  	end
  	return false
  end

  def self.get_band_invites_for(user_id)
  	notes = Notification.where(user_id: user_id)
  	final_set = []
  	for note in notes
  		if note.is_band_invite?
  			final_set.push(note)
  		end
  	end
  	return final_set
  end

  private
end
