class FixingStates < ActiveRecord::Migration
  def change
  	remove_column :states, :gop_pledged
  	remove_column :states, :gop_unpledged
  	remove_column :states, :dem_pledged
  	remove_column :states, :dem_unpledged
  end
end
