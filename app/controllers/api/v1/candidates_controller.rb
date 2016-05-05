class Api::V1::CandidatesController < Api::V1::BaseController
	def index
		plain_candidates = Candidate.all
		@candidates = {}
		plain_candidates.each do |candidate|
			@candidates[candidate.id] = {first_name: candidate.first_name, last_name: candidate.last_name, party: Party.find_by(id: candidate.party_id).name, thumbnail: 'http://s3-us-west-2.amazonaws.com/elasticbeanstalk-us-west-2-762356920553/candidates/profiles/000/000/' + format('%03d', candidate.id) + '/thumb/' + candidate.profile_file_name, medium: 'http://s3-us-west-2.amazonaws.com/elasticbeanstalk-us-west-2-762356920553/candidates/profiles/000/000/' + format('%03d', candidate.id) + '/medium/' + candidate.profile_file_name, original: 'http://s3-us-west-2.amazonaws.com/elasticbeanstalk-us-west-2-762356920553/candidates/profiles/000/000/' + format('%03d', candidate.id) + '/original/' + candidate.profile_file_name}
		end
		render json: @candidates
	end

	def show
		@candidate = Candidate.find(params[:id])
		render json: @candidate
	end
end

