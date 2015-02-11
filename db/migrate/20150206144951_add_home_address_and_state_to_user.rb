class AddHomeAddressAndStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :home_address, :string
    add_column :users, :state, :string
  end
end
