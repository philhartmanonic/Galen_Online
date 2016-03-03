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
					if (q.name =~ /Senate/).nil? and (q.name =~ /Governor/).nil? and (q.name =~ / GE/).nil?
						c = q.responses
						c.each do |r|
							if r[:party] == "Dem"
								b[:Results].append([r[:choice], r[:value]])
							end
						end
					end
				end
				b[:Results].sort_by! {|k| k[1] * -1}
				poll_data.append(b)
			end
			poll_data.sort_by! {|k| [Date.today - k[:"End Date"]]}
			return poll_data
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
					if (q.name =~ /Senate/).nil? and (q.name =~ /Governor/).nil? and (q.name =~ / GE/).nil?
						c = q.responses
						c.each do |r|
							if r[:party] == "Rep"
								b[:Results].append([r[:choice], r[:value]])
							end
						end
					end
				end
				b[:Results].sort_by! {|k| k[1] * -1}
				poll_data.append(b)
			end
			poll_data.sort_by! {|k| [Date.today - k[:"End Date"]]}
			return poll_data
		end
	end

	def dem_winner
		if self.dem_date.nil? == false and self.dem_date <= Date.today and Election.where('state_id = ? AND party_id = ?', self.id, 2).empty? == false 
			a = self.elections
			b = ['', 0, 0]
			a.each do |e|
				if e.party_id = 2
					if b[1] < e.percent or (b[1] == e.percent and b[2] < e.regs)
						b = [Candidate.find_by(id: e.candidate_id).last_name, e.percent, e.regs]
					end
				end
			end
			return "#{b[0]}: #{b[1].to_s}%, #{b[2].to_s} delegates"
		else
			a = self.dem_polls.select {|i| i.nil? == false and ((i.kind_of?(Array)) or (i.kind_of?(Hash) and i[:Results][0].nil? == false))}.first
			i = 1

			if a.nil?
				return "No polls in this state"
			end

			while a.kind_of?(Hash) and a[:Results][0].nil?
				a = self.dem_polls.select[i]
				i += 1
			end
	
			if a.kind_of?(Hash)
				b = [a[:Results][0][0], a[:Results][0][1]]
				done = true
				return "(Poll) #{b[0]}: #{b[1].to_s}%"
			else
				return "No polls in this state"
			end
		end
	end

	def gop_winner
		if self.gop_date <= Date.today and Election.where('state_id = ? AND party_id = ?', self.id, 1).empty? == false 
			a = self.elections.where(party_id: 1)
			b = ['', 0, 0]
			a.each do |e|
				if b[1] < e.percent or (b[1] == e.percent and b[2] < e.regs)
					b = [Candidate.find_by(id: e.candidate_id).last_name, e.percent, e.regs]
				end
			end
			return "#{b[0]}: #{b[1].to_s}%, #{b[2].to_s} delegates"
		else
			a = self.gop_polls.select {|i| i.nil? == false and ((i.kind_of?(Array)) or (i.kind_of?(Hash) and i[:Results][0].nil? == false))}.first
			i = 1

			if a.nil?
				return "No polls in this state"
			end

			while a.kind_of?(Hash) and a[:Results][0].nil?
				a = self.gop_polls.select[i]
				i += 1
			end
	
			if a.kind_of?(Hash)
				b = [a[:Results][0][0], a[:Results][0][1]]
				done = true
				return "(Poll) #{b[0]}: #{b[1].to_s}%"
			else
				return "No polls in this state"
			end
		end
	end
end
