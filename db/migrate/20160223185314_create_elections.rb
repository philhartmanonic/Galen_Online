class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
    	t.belongs_to :state, index: true
    	t.belongs_to :candidate, index: true
    	t.belongs_to :party
    	t.integer :percent
    	t.integer :regs
    	t.integer :supers
    	t.timestamps null: false
    end
  end
end
