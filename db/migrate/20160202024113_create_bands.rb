class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.string :fb_id
      t.string :thumb_url

      t.timestamps null: false
    end
  end
end
