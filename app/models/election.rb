require 'csv'
class Election < ActiveRecord::Base
	belongs_to :candidate
	belongs_to :state
	belongs_to :party

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			election = Election.find_or_initialize_by(party_id: row["party_id"], state_id: row["state_id"], candidate_id: row["candidate_id"])
			if election.update(row.to_hash)
				true
			else
				false
			end
		end
	end
end
