class State < ActiveRecord::Base
	require 'csv'
	require 'pollster'
	include Pollster
	has_attached_file :map, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :map, content_type: /\Aimage\/.*\Z/

	def self.import(file)
		CSV.foreach(file.path, headers: true) do |row|
			state = State.find_or_initialize_by(name: row["name"])
			if state.update(row.to_hash)
				true
			else
				false
			end
		end
	end

	def formatted_dem_date
		self.dem_date.strftime('%B %d')
	end

	def formatted_gop_date
		self.gop_date.strftime('%B %d')
	end
	
	def both
		self.gop_date == self.dem_date
	end

	def gop_own
		self.both == false and self.gop_date.present?
	end

	def dem_own
		self.both == false and self.dem_date.present?
	end

	def dem_polls
		begin
			chart = Pollster::Chart.find(self.dem_poll_slug)
		rescue Exception
			return ["Message", "There are no Democratic polls for this state"]
		else
			polls = chart.polls
			poll_data = []
			polls.each do |p|
				a = p.questions
				b = {"Pollster": p.pollster, "Start Date": p.start_date, "End Date": p.end_date, "Results": []}
				a.each do |q|
					c = q.responses
					c.each do |r|
						if r[:party] == "Dem" and r[:topic] == "2016-president-dem-primary"
							b[:Results].append([r[:choice], r[:value]])
						end
					end
				end
				b[:Results].sort_by! {|k| k[1] * -1}
				poll_data.append(b)
			end
			pd = poll_data.sort_by {|k| k[:end_date]}
			return pd
		end
	end
	def gop_polls
		begin
			chart = Pollster::Chart.find(self.gop_poll_slug)
		rescue Exception
			return ["Message", "There are no Republican polls for this state"]
		else
			polls = chart.polls
			poll_data = []
			polls.each do |p|
				a = p.questions
				b = {"Pollster": p.pollster, "Start Date": p.start_date, "End Date": p.end_date, "Results": []}
				a.each do |q|
					c = q.responses
					c.each do |r|
						if r[:party] == "Rep" and r[:topic] == "2016-president-rep-primary"
							b[:Results].append([r[:choice], r[:value]])
						end
					end
				end
				b[:Results].sort_by! {|k| k[1] * -1}
				poll_data.append(b)
			end
			pd = poll_data.sort_by {|k| k[:end_date]}
			return pd
		end
	end
end
