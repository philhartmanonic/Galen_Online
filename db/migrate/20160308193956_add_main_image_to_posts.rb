class AddMainImageToPosts < ActiveRecord::Migration
  def change
  	add_attachment :posts, :main_image
  end
end
