class CandidatesController < ApplicationController
	def import
    	Candidate.import(params[:file])
    	redirect_to candidates_path, notice: "Candidate Data imported!"
	end

    def index
        @candidates = Candidate.all
    end
	private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate
    	@election = Candidate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
    	params.require(:candidate).permit(:first_name, :last_name, :party_id)
    end
end
