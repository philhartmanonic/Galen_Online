class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.string :name
      t.string :fb_id
      t.string :fb_name
      t.integer :likes_count
      t.integer :ta_count
      t.string :pic_url
      t.integer :follower_count
      t.integer :following_count
      t.integer :tweets

      t.timestamps null: false
    end
  end
end
