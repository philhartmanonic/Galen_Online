class State < ActiveRecord::Base
	require 'csv'
	require 'pollster'
	include Pollster
	has_attached_file :map, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
	validates_attachment_content_type :map, content_type: /\Aimage\/.*\Z/
	has_many :elections
	has_many :candidates, through: :elections

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
		if self.dem_date.nil?
			"No date set"
		else
			self.dem_date.strftime('%B %d')
		end
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

	def dem_left
		if self.dem_date - Date.today > 0
			return (self.dem_date - Date.today).to_i
		elsif self.dem_date == Date.today
			return "Today"
		else
			return "Past"
		end
	end

	def gop_left
		if self.gop_date - Date.today > 0
			return (self.gop_date - Date.today).to_i
		elsif self.gop_date == Date.today
			return "Today"
		else
			return "Past"
		end
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
					if (q.name =~ /Senate/).nil? and (q.name =~ /Gubernatorial/).nil? and (q.name =~ /Governor/).nil? and (q.name =~ / GE/).nil?
						c = q.responses
						c.each do |r|
							if r[:party] == "Dem"
								b[:Results].append([r[:choice], r[:value]])
							end
						end
					end
				end
				if b[:Results].empty? == false
					b[:Results].sort_by! {|k| k[1] * -1}
					poll_data.append(b)
				end
			end
			if poll_data.empty? == false
				poll_data.sort_by! {|k| [Date.today - k[:"End Date"]]}
				return poll_data
			else
				return ["Message", "There are no Democratic polls for this state"]
			end
		end
	end
	def dem_latest
		begin
			poll = Pollster::Poll.where(chart: self.dem_poll_slug).first
		rescue Exception
			return ["Message", "There are no Democratic polls for this state"]
		else
			a = poll.questions
			b = {"Pollster": poll.pollster, "Start Date": poll.start_date, "End Date": poll.end_date, "Results": []}
			a.each do |q|
				if (q.name =~ /Senate/).nil? and (q.name =~ /Gubernatorial/).nil? and (q.name =~ /Governor/).nil? and (q.name =~ / GE/).nil?
					c = q.responses
					c.each do |r|
						if r[:party] == "Dem"
							b[:Results].append([r[:choice], r[:value]])
						end
					end
				end
			end
			if b[:Results].empty? == false
				b[:Results].sort_by! {|k| k[1] * -1}
				return b
			else
				return ["Message", "There are no Democratic polls for this state"]
			end
		end
	end


	def gop_polls
		begin
			polls = Pollster::Chart.find(self.gop_poll_slug).polls
		rescue Exception
			return ["Message", "There are no Republican polls for this state"]
		else
			poll_data = []
			polls.each do |p|
				a = p.questions
				b = {"Pollster": p.pollster, "Start Date": p.start_date, "End Date": p.end_date, "Results": []}
				a.each do |q|
					if (q.name =~ /Senate/).nil? and (q.name =~ /Gubernatorial/).nil? and (q.name =~ /Governor/).nil? and (q.name =~ / GE/).nil?
						c = q.responses
						c.each do |r|
							if r[:party] == "Rep"
								b[:Results].append([r[:choice], r[:value]])
							end
						end
					end
				end
				if b[:Results].empty? == false
					b[:Results].sort_by! {|k| k[1] * -1}
					poll_data.append(b)
				end
			end
			if poll_data.empty? == false
				poll_data.sort_by! {|k| [Date.today - k[:"End Date"]]}
				return poll_data
			else
				return ["Message", "There are no Republican polls for this state"]
			end
		end
	end

	def gop_latest
		begin
			poll = Pollster::Poll.where(chart: self.gop_poll_slug).first
		rescue Exception
			return ["Message", "There are no Democratic polls for this state"]
		else
			a = poll.questions
			b = {"Pollster": poll.pollster, "Start Date": poll.start_date, "End Date": poll.end_date, "Results": []}
			a.each do |q|
				if (q.name =~ /Senate/).nil? and (q.name =~ /Gubernatorial/).nil? and (q.name =~ /Governor/).nil? and (q.name =~ / GE/).nil?
					c = q.responses
					c.each do |r|
						if r[:party] == "Rep"
							b[:Results].append([r[:choice], r[:value]])
						end
					end
				end
			end
			if b[:Results].empty? == false
				b[:Results].sort_by! {|k| k[1] * -1}
				return b
			else
				return ["Message", "There are no Democratic polls for this state"]
			end
		end
	end
end
