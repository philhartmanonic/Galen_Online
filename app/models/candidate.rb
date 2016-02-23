require 'csv'
class Candidate < ActiveRecord::Base
  belongs_to :party
  has_many :elections
  has_many :states, through: :elections

  def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			candidate = Candidate.find_or_initialize_by(last_name: row["last_name"])
			if candidate.update(row.to_hash)
				true
			else
				false
			end
		end
	end

	def full_name
		return self.first_name + " " + self.last_name
	end
end
