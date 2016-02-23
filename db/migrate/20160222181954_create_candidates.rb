class CreateCandidates < ActiveRecord::Migration
  def change
    create_table :candidates do |t|
      t.string :first_name
      t.string :last_name
      t.string :pollster_slug
      t.references :party, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
