class CreateRoles < ActiveRecord::Migration
  def up
  	drop_table 'roles' if ActiveRecord::Base.connection.table_exists? 'roles'
    create_table :roles do |t|
      t.string :name
      t.string :description

      t.timestamps null: false
    end
  end
end
