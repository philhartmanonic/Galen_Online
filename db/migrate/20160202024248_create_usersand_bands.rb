class CreateUsersandBands < ActiveRecord::Migration
  def change
    create_table :users_bands do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :band, index: true
    end
  end
end
