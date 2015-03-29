class Notification < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true

  validate :not_duplicate

  private

  	def not_duplicate
  	end
end
