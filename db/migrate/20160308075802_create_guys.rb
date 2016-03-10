class CreateGuys < ActiveRecord::Migration
  def change
    create_table :guys do |t|
      t.datetime :bd

      t.timestamps null: false
    end
  end
end
