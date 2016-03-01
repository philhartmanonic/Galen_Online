require 'csv'
class Candidate < ActiveRecord::Base
  belongs_to :party
  has_many :elections
  has_many :states, through: :elections
  accepts_nested_attributes_for :elections
  has_attached_file :profile, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :profile, content_type: /\Aimage\/.*\Z/

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

	def regulars
		d = 0
		self.elections.load
		self.elections.each do |e|
			d += e.regs
		end
		return d
	end

	def supers
		d = 0
		self.elections.load
		if self.party.name == "Democratic"
			self.elections.each do |e|
				d += e.supers
			end
		end
		return d
	end

	def total
		return regulars + supers
	end

	def needs
		return (self.party.win_number / 2).ceil - total
	end
end
