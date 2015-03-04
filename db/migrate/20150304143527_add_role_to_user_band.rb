class AddRoleToUserBand < ActiveRecord::Migration
  def change
    add_column :user_bands, :role, :string
  end
end
