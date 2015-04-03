class UserTags < ActiveRecord::Base
	validates :user_id, uniqueness: {scope: :tag_id}
end
