require 'csv'
class Party < ActiveRecord::Base
	has_many :candidates
	has_many :elections

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			party = Party.find_or_initialize_by(name: row["name"])
			if party.update(row.to_hash)
				true
			else
				false
			end
		end
	end
end
