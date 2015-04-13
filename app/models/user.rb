class User < ActiveRecord::Base
  has_secure_password

  has_many :notifications
  
  has_many :user_bands
  has_many :bands, through: :user_bands

  has_many :user_tags
  has_many :tags, through: :user_tags

  validates :display_name, presence: true, uniqueness: {case_sensitive: false}

  validates_acceptance_of :terms
  validates :email, presence: true,
                    uniqueness: true,
                    format: {
                      with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
                    },
                    confirmation: true
  validates :email_confirmation, presence: true

  before_save :downcase_email

  #For location (Geocoder)
  geocoded_by :get_address
  after_validation :geocode, :if => :get_address_changed?

  #For image uploading (paperclip)
  has_attached_file(:profile_picture,
                  :default_url => 'user/profile_pictures/default_:style.png',
                  :styles => { medium: "300x300#", small: "150x150#",thumb: "60x60#"})
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/



  def downcase_email
    self.email = email.downcase
  end

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48))
  end

  def get_age
    return Date.today.year - dob.to_i
  end

  #Location is geocoded by this!
  def get_address
    if(!self.city.nil? && (!self.state.nil?))
      return self.city + ", "+ self.state
    end
    return self.address
  end

  def get_address_changed?
    :city_changed? || :state_changed?
  end

  # ------- Map Stuff --------
  def gmaps_infowindow
      "Hello"
      "<img src=\"#{self.profile_picture(:thumb)}\"> #{self.display_name}"
  end

  #--------------------------- Tag stuff ------------------------------------

  def num_tags
    usertags = UserTags.where(user_id: self.id)
    return usertags.count
  end

  def get_tags
    usertags = UserTags.where(user_id: self.id)
    tags = []
    for usertag in usertags
      tags.push(usertag.tag_id)
    end
    return tags
  end

  def has_tags?(tag_ids)
    user_tags = self.get_tags
    for tag_id in tag_ids
      if (!user_tags.include?(tag_id.to_i))
        return false
      end
    end
    return true
  end

  def has_tag?(tag_id)
    user_tags = self.get_tags
    if (!user_tags.include?(tag_id))
      return false
    else
      return true
    end
  end

  def has_at_least_one_tag_from?(tag_ids)
    for tag_id in tag_ids
      if !UserTags.find_by(tag_id: tag_id, user_id: self.id).nil?
        return true
      end
    end

    return false
  end

  def get_matching_tag_ids(tag_ids)
    usertags = UserTags.find_by(user_id: self.id)
    matching = []
    for usertag in UserTags
      if tag_ids.include?(usertag.id)
        matching.push(usertag.id)
      end
    end
    return matching
  end

  # --------------------------- Some Band code -------------------------------

  #Return all bands the user is a member of
  def get_bands
    userbands = UserBand.where(user_id: id)
    bands = []
    for userband in userbands
      bands.push(Band.find(userband.band_id))
    end
    return bands
  end

  #Return all users this user is in a band with
  def is_in_band_with_users
    bands = get_bands

    other_users = []
    for band in bands
      userbands = UserBand.where(band_id: band.id)
      for userband in userbands
        if userband.user_id != id
          other_users.push(User.find(userband.user_id))
        end
      end
    end
    return other_users
  end

  def get_shared_bands_with(user_id)
    user = User.find(user_id)
    other_bands = user.get_bands
    my_bands = get_bands
    shared_bands = my_bands & other_bands
  end

  def get_number_of_shared_bands_with(user_id)
    bands = get_shared_bands_with(user_id)
    return bands.count
  end

  def self.destroy_user_by_id(user_id)
    user = User.find(user_id).destroy
    for userband in UserBand.where(user_id: user_id)
      userband.destroy
    end

    for tag in UserTags.where(user_id)
      tag.destroy
    end
  end

  # -------------------------- Notification stuff ------------------------

  def band_invites
    return Notification.get_band_invites_for(id)
  end

  def num_notifications
    return Notification.where(user_id: id).count
  end

end