class Api::V1::StatesController < Api::V1::BaseController
	def calendar
		@states = State.all
	    dem_states = State.includes(:elections, :candidates).where("elections.party_id = 2").references(:elections)
	    gop_states = State.includes(:elections, :candidates).where("elections.party_id = 1").references(:elections)
	    @calendar_states = []
	    dem_winners = {}
	    gop_winners = {}
	    dem_states.each do |s|
	    	if s.dem_date <= Date.today
	        	a = s.elections.sort_by {|k| [-k.percent, -k.regs]}.first
	        	dem_winners[s.id] = "#{a.candidate.last_name}: #{a.percent}%, #{a.regs} delegates"
	    	end
	    end
	    gop_states.each do |s|
	    	a = s.elections.sort_by {|k| [-k.percent, -k.regs]}.first
	      	gop_winners[s.id] = "#{a.candidate.last_name}: #{a.percent}%, #{a.regs} delegates"
	    end 
	    @states.each do |s|
	    	if gop_winners.has_key?(s.id) == false
	        	gop_winners[s.id] = "Vote on #{s.formatted_gop_date}"
	    	end
	      	if dem_winners.has_key?(s.id) == false
	        	dem_winners[s.id] = "Vote on #{s.formatted_dem_date}"
	      	end
	      	if s.gop_own == true
	        	@calendar_states << {state: s, name: s.name, date: s.gop_date, type: s.p_or_c, gop: gop_winners[s.id], dem: dem_winners[s.id], party: 'Republican'}
	      	end
	      	if s.dem_own == true
	        	@calendar_states << {state: s, name: s.name, date: s.dem_date, type: s.p_or_c, gop: gop_winners[s.id], dem: dem_winners[s.id], party: 'Democratic'}
	      	end
	      	if s.both == true
	        	@calendar_states << {state: s, name: s.name, date: s.gop_date, type: s.p_or_c, gop: gop_winners[s.id], dem: dem_winners[s.id], party: 'Both'}
	      	end
	    end
	    @cs = @calendar_states.sort_by { |k| k[:date] }.group_by {|k| k[:date].strftime('%B')}
	    render json: @cs
	end

	def show
	    plain_state = State.find(params[:id])
	    @state = {id: plain_state.id, name: plain_state.name, p_or_c: plain_state.p_or_c, dem_date: plain_state.dem_date, gop_date: plain_state.gop_date, dem_results: ['None'], gop_results: ['None']}
	    @state[:dem_results] = plain_state.elections.where(party_id: 2) if (plain_state.elections.where(party_id: 2).empty? == false) and (plain_state.dem_date < Date.today)
	    @state[:gop_results] = plain_state.elections.where(party_id: 1) if (plain_state.elections.where(party_id: 1).empty? == false) and (plain_state.gop_date < Date.today)
	    render json: @state
  	end

  	def index
  		@states = State.all
  		render json: @states
  	end
end