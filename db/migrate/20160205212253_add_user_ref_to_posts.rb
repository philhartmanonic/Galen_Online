class AddUserRefToPosts < ActiveRecord::Migration
  def up
  	remove_column :posts, :user_id if column_exists? :posts, :user_id
    add_reference :posts, :user, index: true, foreign_key: true
  end
end
