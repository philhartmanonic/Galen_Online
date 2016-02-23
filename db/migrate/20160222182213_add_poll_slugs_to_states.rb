class AddPollSlugsToStates < ActiveRecord::Migration
  def change
  	add_column :states, :dem_poll_slug, :string
  	add_column :states, :gop_poll_slug, :string
  end
end
