class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.string :location
      t.string :about_me

      t.timestamps
    end
  end
end
