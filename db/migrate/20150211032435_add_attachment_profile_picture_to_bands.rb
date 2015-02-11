class AddAttachmentProfilePictureToBands < ActiveRecord::Migration
  def self.up
    change_table :bands do |t|
      t.attachment :profile_picture
    end
  end

  def self.down
    remove_attachment :bands, :profile_picture
  end
end
