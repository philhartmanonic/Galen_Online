class PartiesController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource :except => [:dashboard]

	def import
    	Party.import(params[:file])
    	redirect_to states_path, notice: "Party Data imported!"
	end

    def dashboard
        @parties = Party.all
        @candidates = Candidate.all
        @elections = Election.all
        @states = State.all
        @dems = Candidate.where(party_id: 2).sort_by{|p| -(p.total)}
        @reps = Candidate.where(party_id: 1).sort_by{|p| -(p.total)}
        @demstates = State.where("dem_date < ?", Date.today + 14).where("dem_date >= ?", Date.today).order("dem_date asc")
        @repstates = State.where("gop_date < ?", Date.today + 14).where("gop_date >= ?", Date.today).order("gop_date asc")
        @grouped_elections = @elections.order("percent desc").group_by { |i| [i.state_id, i.party_id]}
        @dem_elections = @grouped_elections.select {|k, v| k[1] == 2 }.sort_by{|k, v| [State.find_by(id: k[0]).dem_date] }
        @gop_elections = @grouped_elections.select {|k, v| k[1] == 1 }.sort_by{|k, v| [State.find_by(id: k[0]).gop_date] }
    end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
    	@party = Party.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_params
    	params.require(:party).permit(:name, candidates_attributes: [:first_name, :last_name, :party_id], elections_attributes: [:state_id, :candidate_id, :party_id, :percent, :regs, :supers], state_attributes: [:name, :p_or_c, :dem_date, :gop_date])
    end
end
