class AddWinNumberToParties < ActiveRecord::Migration
  def change
  	add_column :parties, :win_number, :integer
  end
end
