class AddAssociations < ActiveRecord::Migration
  def change
  	add_reference(:users, :role)
  	add_reference(:posts, :user)
  	add_reference(:pics, :post)
  end
end
