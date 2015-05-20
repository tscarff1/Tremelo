class AddCityAndStateToBand < ActiveRecord::Migration
  def change
    add_column :bands, :city,  :string
    add_column :bands, :state, :string
  end
end
