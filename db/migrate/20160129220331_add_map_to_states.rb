class AddMapToStates < ActiveRecord::Migration
  def up
  	add_attachment :states, :map
  end

  def down
  	remove_attachment :states, :map
  end
end
