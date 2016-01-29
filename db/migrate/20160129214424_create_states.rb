class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name
      t.string :p_or_c
      t.date :gop_date
      t.date :dem_date
      t.integer :gop_pledged
      t.integer :gop_unpledged
      t.integer :dem_pledged
      t.integer :dem_unpledged

      t.timestamps null: false
    end
  end
end
