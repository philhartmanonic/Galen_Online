class DropGuyModel < ActiveRecord::Migration
  def change
  	drop_table :guys
  end
end
