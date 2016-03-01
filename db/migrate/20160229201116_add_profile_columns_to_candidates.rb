class AddProfileColumnsToCandidates < ActiveRecord::Migration
  def change
  	add_attachment :candidates, :profile
  end
end
