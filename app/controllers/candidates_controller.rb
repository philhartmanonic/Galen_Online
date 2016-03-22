clasclass CandidatesController < ApplicationController
    before_action :set_candidate, only: [:show, :edit, :update, :destroy]
    load_and_authorize_resource :except => [:show]

	def import
    	Candidate.import(params[:file])
    	redirect_to candidates_path, notice: "Candidate Data imported!"
	end

    def index
        @candidates = Candidate.all
    end

    def new
        @candidates = Candidate.all
        @candidate = Candidate.new
    end

    def show
        @candidates = Candidate.all
        @candidate = Candidate.find(params[:id])
    end

    def edit
        @candidates = Candidate.all
        @candidate = Candidate.find(params[:id])
    end

    def create
        @candidate = Candidate.new(candidate_params)

        respond_to do |format|
            if @candidate.save
                format.html { redirect_to @candidate, notice: 'Candidate was successfully created.' }
                format.json { render :show, status: :created, location: @candidate }
            else
                format.html { render :new }
                format.json { render json: @candidate.errors, status: :unprocessable_entity }
            end
        end
    end

    def update
        @candidate = Candidate.find(params[:id])

        respond_to do |format|
            if @candidate.update(candidate_params)
                format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
                format.json { render :show, status: :ok, location: @candidate }
            else
                format.html { render :edit }
                format.json { render json: @candidate.errors, status: :unprocessable_entity }
            end
        end
    end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_candidate
    	@election = Candidate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def candidate_params
    	params.require(:candidate).permit(:first_name, :last_name, :party_id, :profile, parties_attributes: [:name])
    end
end
