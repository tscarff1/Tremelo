class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.string :string
      t.string :location
      t.string :string
      t.string :aboout_me

      t.timestamps
    end
  end
end
