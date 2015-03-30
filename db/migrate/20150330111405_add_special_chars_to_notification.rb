class AddSpecialCharsToNotification < ActiveRecord::Migration
  def change
    add_column :notifications, :special_chars, :string
  end
end
