class PartiesController < ApplicationController
	def import
    	Party.import(params[:file])
    	redirect_to states_path, notice: "Party Data imported!"
	end
	private
    # Use callbacks to share common setup or constraints between actions.
    def set_party
    	@party = Party.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_params
    	params.require(:party).permit(:name)
    end
end
