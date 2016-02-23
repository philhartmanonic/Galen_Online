class ElectionsController < ApplicationController
	def import
    	Election.import(params[:file])
    	redirect_to elections_path, notice: "Election Data imported!"
	end

    def index
        @elections = Election.all
        @grouped_elections = @elections.order("percent desc").group_by { |i| [i.state_id, i.party_id]}
        @states = State.all
        @parties = Party.all
    end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_election
    	@election = Election.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def election_params
    	params.require(:election).permit(:state_id, :candidate_id, :party_id, :percent, :supers, :regs, states_attributes: [:id, :name], parties_attributes: [:id, :name], candidates_attributes: [:id, :first_name, :last_name])
    end
end
