class CreateUserBands < ActiveRecord::Migration
  def change
    create_table :user_bands do |t|
      t.integer :user_id
      t.integer :band_id
      t.integer :admin_priveleges

      t.timestamps
    end
  end
end
