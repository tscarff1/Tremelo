class AddFullAddressToBand < ActiveRecord::Migration
  def change
    add_column :bands, :full_address, :string
  end
end
