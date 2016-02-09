class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
    	t.boolean :up, default: true, null: false
    	t.references :takes_votes, :polymorphic => true
    	t.references :user, index: true, foreign_key: true
    	t.timestamps null: false
    end
  end
end
