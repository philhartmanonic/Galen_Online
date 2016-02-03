class BandsUsers < ActiveRecord::Migration
  def change
  	create_table :bands_users, id: false do |t|
  		t.belongs_to :band, index: true
  		t.belongs_to :user, index: true
  	end
  end
end
