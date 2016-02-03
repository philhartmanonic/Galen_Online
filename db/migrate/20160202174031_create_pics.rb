class CreatePics < ActiveRecord::Migration
  def change
    create_table :pics do |t|

      t.timestamps null: false
    end
  end
end
