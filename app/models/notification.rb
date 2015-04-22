class Notification < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, uniqueness: true
  after_create :notify_user

  #View notifiations at users/notifications

  # Special Characters List
  # none - Generic Notification (ie, band uploaded a video)
  # %B Band Invitation
  # %b user requesting membership to a band
  # %m Message
  # %M Formatted message (Just an idea)
  #  

  # ------------------------------- Band Invites -------------------------------
  # How it works: Band selects "add member", which calls the same method from band_controller
  # This creates a new notification for the relevant user
  # User views the notification, selects accept or reject.
  #     Both lead to the 'accept_band' user_controller action with accept = true/false
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
    def notify_user
      Notification.connection.execute "NOTIFY notifications, 'data'"
    end
    # end

    def self.on_change
      Notification.connection.execute "LISTEN notifications"
      loop do
        Notification.connection.raw_connection.wait_for_notify do |event, pid, notification|
          yield notification
        end
      end
    ensure
      Notification.connection.execute "UNLISTEN notifications"
    end

end
