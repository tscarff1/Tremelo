class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true,
                    uniqueness: true,
                    format: {
                      with: /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
                    },
                    confirmation: true

  before_save :downcase_email

  #For location (Geocoder)
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  #For image uploading (paperclip)
  has_attached_file :profile_picture, :styles => { medium: "300x300", thumb: "100x100"}
  validates_attachment_content_type :profile_picture, content_type: /\Aimage\/.*\Z/

  def downcase_email
    self.email = email.downcase
  end

  def generate_password_reset_token!
    update_attribute(:password_reset_token, SecureRandom.urlsafe_base64(48))
  end

  def get_address
    return home_address + ", "+ state
  end

  def get_tags
    usertags = UserTags.where(user_id: self.id)
    tags = []
    for usertag in usertags
      tag_content = Tag.find(usertag.tag_id).content
      tags.push(tag_content)
    end
    return tags
  end

  def has_at_least_one_tag_from?(tag_ids)
      for tag_id in tag_ids
        if !UserTags.find_by(tag_id: tag_id, user_id: self.id).nil?
          return true
        end
      end

      return false
    end
end
