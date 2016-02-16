class State < ActiveRecord::Base
	require 'csv'
	has_attached_file :map, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :map, content_type: /\Aimage\/.*\Z/

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			State.create! row.to_hash
		end
	end

	def formatted_dem_date
		self.dem_date.strftime('%B %d')
	end

	def formatted_gop_date
		self.gop_date.strftime('%B %d')
	end
end
